import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../document_providers.dart';
import '../domain/farm_document.dart';
import 'document_labels.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  DocumentCategory? _filter;
  final _backingUp = <String>{};

  Future<void> _open(FarmDocument doc) async {
    final t = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    try {
      // A document restored from another phone is fetched on first open.
      final path = await ref.read(documentBackupServiceProvider)?.ensureLocalFile(doc) ??
          (File(doc.localPath).existsSync() ? doc.localPath : null);
      final result = path == null ? null : await OpenFilex.open(path);
      if (result == null || result.type != ResultType.done) {
        messenger.showSnackBar(SnackBar(content: Text(t.docOpenFailed)));
      }
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(t.docOpenFailed)));
    }
  }

  Future<void> _backUp(FarmDocument doc) async {
    final t = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _backingUp.add(doc.id));
    try {
      await ref.read(documentBackupServiceProvider)!.backUp(doc);
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(t.docBackupFailed)));
    } finally {
      if (mounted) setState(() => _backingUp.remove(doc.id));
    }
  }

  Future<void> _delete(FarmDocument doc) async {
    final t = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(t.docDeleteConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.cancel)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(t.deleteButton)),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(documentBackupServiceProvider)?.removeCloudCopy(doc);
    } catch (_) {
      // Offline: the local delete still goes ahead; an orphaned cloud file is harmless.
    }
    await ref.read(documentRepositoryProvider).deleteDocument(doc.id);
    await ref.read(documentFileServiceProvider).deleteFile(doc.localPath);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final docs = ref.watch(documentsProvider);
    final fmt = DateFormat('d MMM yyyy');
    final canBackUp = ref.watch(documentBackupServiceProvider) != null;

    return Scaffold(
      appBar: AppBar(title: Text(t.documentsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(
          Uri(path: '/documents/add', queryParameters: {if (_filter != null) 'category': _filter!.name}).toString(),
        ),
        icon: const Icon(Icons.upload_file_rounded),
        label: Text(t.addDocument),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(t.mandiFilterAll),
                      selected: _filter == null,
                      onSelected: (_) => setState(() => _filter = null),
                    ),
                  ),
                  for (final c in DocumentCategory.values)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text('${c.emoji} ${documentCategoryLabel(t, c)}'),
                        selected: _filter == c,
                        onSelected: (_) => setState(() => _filter = _filter == c ? null : c),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: docs.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text(t.genericErrorMessage)),
                data: (all) {
                  final list = _filter == null ? all : all.where((d) => d.category == _filter).toList();
                  if (list.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.folder_open_rounded, size: 48, color: AppColors.textSecondary),
                            const SizedBox(height: 12),
                            Text(
                              t.documentsEmpty,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
                            ),
                            const SizedBox(height: 8),
                            Text(t.docPrivacyNote, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final d = list[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          minTileHeight: 68,
                          onTap: () => _open(d),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryLight,
                            child: Icon(d.isPdf ? Icons.picture_as_pdf_rounded : Icons.image_rounded, color: AppColors.primary),
                          ),
                          title: Text(d.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                          subtitle: Text(
                            '${documentCategoryLabel(t, d.category)} · ${formatFileSize(d.sizeBytes)} · ${fmt.format(d.createdAt)}\n'
                            '${d.isBackedUp ? t.docBackedUp : t.docSavedOnPhone}',
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (canBackUp && !d.isBackedUp)
                                _backingUp.contains(d.id)
                                    ? const Padding(
                                        padding: EdgeInsets.all(12),
                                        child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                                      )
                                    : IconButton(
                                        tooltip: t.docBackUp,
                                        icon: const Icon(Icons.cloud_upload_outlined),
                                        onPressed: () => _backUp(d),
                                      ),
                              if (d.isBackedUp) const Icon(Icons.cloud_done_outlined, color: AppColors.primary),
                              IconButton(
                                tooltip: t.deleteButton,
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _delete(d),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
