import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import '../../../core/utils/error_messages.dart';
import '../../../core/utils/error_reporter.dart';
import '../../../core/utils/ids.dart';
import '../../../l10n/app_localizations.dart';
import '../../dashboard/dashboard_providers.dart';
import '../data/document_file_service.dart';
import '../document_providers.dart';
import '../domain/farm_document.dart';
import 'document_labels.dart';

class AddDocumentScreen extends ConsumerStatefulWidget {
  const AddDocumentScreen({this.initialCategory, super.key});

  final DocumentCategory? initialCategory;

  @override
  ConsumerState<AddDocumentScreen> createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends ConsumerState<AddDocumentScreen> {
  final _title = TextEditingController();
  late DocumentCategory _category = widget.initialCategory ?? DocumentCategory.extract712;
  String? _sourcePath;
  String? _fileName;
  String? _error;
  String? _titleError;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  void _choose(String path, String name) {
    final t = AppLocalizations.of(context)!;
    final size = _sizeOf(path);
    final rejection = DocumentRules.check(name, size);
    setState(() {
      _error = rejection == null ? null : documentRejectionText(t, rejection);
      _sourcePath = rejection == null ? path : null;
      _fileName = rejection == null ? name : null;
      if (rejection == null && _title.text.trim().isEmpty) _title.text = p.basenameWithoutExtension(name);
    });
  }

  int _sizeOf(String path) {
    try {
      return File(path).lengthSync();
    } catch (_) {
      return 0;
    }
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: DocumentRules.allowedExtensions,
      );
      final file = result?.files.single;
      if (file?.path != null) _choose(file!.path!, file.name);
    } catch (e, st) {
      reportError(e, st, context: 'AddDocumentScreen.pickFile');
      if (mounted) showGenericErrorSnackBar(context);
    }
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      // Compressed at pick time so scans stay small.
      final picked = await ImagePicker().pickImage(source: source, maxWidth: 2000, imageQuality: 80);
      if (picked != null) _choose(picked.path, picked.name.isEmpty ? p.basename(picked.path) : picked.name);
    } catch (e, st) {
      reportError(e, st, context: 'AddDocumentScreen.pickPhoto');
      if (mounted) showGenericErrorSnackBar(context);
    }
  }

  Future<void> _save() async {
    final t = AppLocalizations.of(context)!;
    final title = _title.text.trim();
    setState(() => _titleError = title.isEmpty ? t.requiredFieldError : null);
    if (title.isEmpty || _sourcePath == null) return;

    setState(() => _saving = true);
    try {
      final stored = await ref.read(documentFileServiceProvider).importFile(_sourcePath!, displayName: _fileName);
      await ref.read(documentRepositoryProvider).addDocument(
            FarmDocument(
              id: newId(),
              farmId: ref.read(primaryFarmProvider)?.id,
              category: _category,
              title: title,
              localPath: stored.path,
              mimeType: stored.mimeType,
              sizeBytes: stored.sizeBytes,
              createdAt: DateTime.now(),
            ),
          );
      if (mounted) context.pop();
    } on DocumentRejectedException catch (e) {
      if (mounted) setState(() => _error = documentRejectionText(t, e.reason));
    } catch (e, st) {
      reportError(e, st, context: 'AddDocumentScreen.save');
      if (mounted) showGenericErrorSnackBar(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.addDocument)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in DocumentCategory.values)
                  ChoiceChip(
                    label: Text('${c.emoji} ${documentCategoryLabel(t, c)}'),
                    selected: _category == c,
                    onSelected: (_) => setState(() => _category = c),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: t.documentTitleLabel, errorText: _titleError),
              onChanged: (_) {
                if (_titleError != null) setState(() => _titleError = null);
              },
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.attach_file_rounded),
                  label: Text(t.chooseFile),
                ),
                OutlinedButton.icon(
                  onPressed: () => _pickPhoto(ImageSource.camera),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: Text(t.takePhoto),
                ),
                OutlinedButton.icon(
                  onPressed: () => _pickPhoto(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(t.galleryLabel),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  _fileName == null ? Icons.insert_drive_file_outlined : Icons.check_circle,
                  color: _fileName == null ? null : Colors.green,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(_fileName ?? t.noFileChosen)),
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 8),
            Text(t.docPrivacyNote, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 24),
            FilledButton(onPressed: _saving || _sourcePath == null ? null : _save, child: Text(t.save)),
          ],
        ),
      ),
    );
  }
}
