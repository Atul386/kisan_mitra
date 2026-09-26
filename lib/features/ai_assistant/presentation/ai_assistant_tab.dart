import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../core/analytics/analytics_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_reporter.dart';
import '../../../l10n/app_localizations.dart';
import '../ai_providers.dart';
import '../domain/ai_message.dart';
import '../domain/ai_repository.dart';

/// Chat shell wired against [AiRepository] (blueprint §24). Messages are
/// session-only for now — nothing to persist against until a Cloud
/// Function actually answers questions.
class AiAssistantTab extends ConsumerStatefulWidget {
  const AiAssistantTab({super.key});

  @override
  ConsumerState<AiAssistantTab> createState() => _AiAssistantTabState();
}

class _AiAssistantTabState extends ConsumerState<AiAssistantTab> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<AiMessage> _messages = [];
  final _speech = SpeechToText();
  bool _speechReady = false;
  bool _listening = false;
  bool _sending = false;

  @override
  void dispose() {
    _speech.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Fills the text box with what the farmer says, in the app's language,
  /// so they can check it before sending.
  Future<void> _toggleListening() async {
    final t = AppLocalizations.of(context)!;
    if (_listening) {
      await _speech.stop();
      setState(() => _listening = false);
      return;
    }
    if (!_speechReady) {
      _speechReady = await _speech.initialize(
        onStatus: (status) {
          if (mounted && (status == SpeechToText.doneStatus || status == SpeechToText.notListeningStatus)) {
            setState(() => _listening = false);
          }
        },
        onError: (_) {
          if (mounted) setState(() => _listening = false);
        },
      );
    }
    if (!mounted) return;
    if (!_speechReady) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.voiceUnavailableMessage)));
      return;
    }
    final languageCode = Localizations.localeOf(context).languageCode;
    setState(() => _listening = true);
    await _speech.listen(
      onResult: (result) {
        _controller.text = result.recognizedWords;
        _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
      },
      listenOptions: SpeechListenOptions(
        localeId: '${languageCode}_IN',
        partialResults: true,
        pauseFor: const Duration(seconds: 3),
        listenFor: const Duration(seconds: 30),
      ),
    );
  }

  Future<void> _send([String? preset]) async {
    if (preset != null) _controller.text = preset;
    final question = _controller.text.trim();
    if (question.isEmpty || _sending) return;
    final t = AppLocalizations.of(context)!;

    setState(() {
      _messages.add(AiMessage(text: question, isUser: true));
      _controller.clear();
      _sending = true;
    });
    _scrollToEnd();
    ref.read(analyticsServiceProvider).logEvent('ai_question_asked');

    try {
      final answer = await ref
          .read(aiRepositoryProvider)
          .ask(question: question, languageCode: Localizations.localeOf(context).languageCode);
      setState(() => _messages.add(AiMessage(text: answer, isUser: false)));
    } on AiNotConfiguredException {
      setState(() => _messages.add(AiMessage(text: t.aiNotConfiguredMessage, isUser: false)));
    } catch (e, st) {
      reportError(e, st, context: 'AiAssistantTab.send');
      setState(() => _messages.add(AiMessage(text: t.genericErrorMessage, isUser: false)));
    } finally {
      if (mounted) setState(() => _sending = false);
      _scrollToEnd();
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.askKisanMitra)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? _SuggestedQuestions(onSelected: _send)
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, i) => _MessageBubble(message: _messages[i]),
                    ),
            ),
            if (_sending) const LinearProgressIndicator(minHeight: 2),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: _listening ? t.voiceListeningLabel : t.aiAssistantHint,
                        ),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      onPressed: _sending ? null : _toggleListening,
                      isSelected: _listening,
                      icon: const Icon(Icons.mic_none_rounded),
                      selectedIcon: const Icon(Icons.mic_rounded, color: AppColors.error),
                      tooltip: t.voiceInputTooltip,
                    ),
                    const SizedBox(width: 4),
                    IconButton.filled(
                      onPressed: _sending ? null : () => _send(),
                      icon: const Icon(Icons.send),
                      tooltip: t.aiAssistantSend,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestedQuestions extends StatelessWidget {
  const _SuggestedQuestions({required this.onSelected});

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final questions = [
      t.suggestedQuestionPest,
      t.suggestedQuestionFertilizer,
      t.suggestedQuestionIrrigation,
      t.suggestedQuestionWeather,
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          t.aiAssistantHint,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 20),
        Text(t.suggestedQuestionsLabel, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        const SizedBox(height: 8),
        for (final q in questions)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(Icons.help_outline_rounded, color: AppColors.primary),
              title: Text(q),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => onSelected(q),
            ),
          ),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final AiMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primaryLight : AppColors.surface,
          border: isUser ? null : Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(message.text),
      ),
    );
  }
}
