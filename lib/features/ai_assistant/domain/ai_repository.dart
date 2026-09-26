/// The UI talks to this interface only — never to an AI provider directly
/// (blueprint §24: API keys must never live in the Flutter app). Until a
/// Cloud Function exists, [UnconfiguredAiRepository] throws
/// [AiNotConfiguredException] so the chat screen can show a clear,
/// honest message instead of pretending to answer.
abstract class AiRepository {
  Future<String> ask({required String question, required String languageCode});
}

class AiNotConfiguredException implements Exception {
  const AiNotConfiguredException([
    this.message = 'The AI assistant is not connected yet.',
  ]);

  final String message;

  @override
  String toString() => message;
}
