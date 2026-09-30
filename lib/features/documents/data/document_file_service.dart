import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/utils/ids.dart';
import '../domain/farm_document.dart';

/// Copies picked files into the app's private storage and removes them
/// again. Validation happens here, before anything is written.
class DocumentFileService {
  const DocumentFileService();

  /// Stores [sourcePath] privately. Throws [DocumentRejectedException] for a
  /// type or size the locker doesn't accept.
  Future<({String path, String mimeType, int sizeBytes})> importFile(String sourcePath, {String? displayName}) async {
    final name = displayName ?? p.basename(sourcePath);
    final source = File(sourcePath);
    final size = await source.length();
    final rejection = DocumentRules.check(name, size);
    if (rejection != null) throw DocumentRejectedException(rejection);

    final dir = Directory(p.join((await getApplicationDocumentsDirectory()).path, 'documents'));
    await dir.create(recursive: true);
    final dest = p.join(dir.path, '${newId()}${p.extension(name).toLowerCase()}');
    await source.copy(dest);
    return (path: dest, mimeType: DocumentRules.mimeTypeFor(name)!, sizeBytes: size);
  }

  Future<void> deleteFile(String path) async {
    try {
      final f = File(path);
      if (await f.exists()) await f.delete();
    } catch (_) {
      // A leftover file is harmless; the database row is what matters.
    }
  }
}

class DocumentRejectedException implements Exception {
  const DocumentRejectedException(this.reason);
  final DocumentRejection reason;
}
