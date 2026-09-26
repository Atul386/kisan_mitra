import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'ids.dart';

/// Copies a picked image into the app's own documents directory so it
/// survives after the picker's temp file is cleaned up (blueprint §27:
/// "keep thumbnail locally"). Returns the new local path.
Future<String> saveImageLocally(XFile picked, {required String category}) async {
  final documentsDir = await getApplicationDocumentsDirectory();
  final destDir = Directory(p.join(documentsDir.path, category));
  await destDir.create(recursive: true);
  final destPath = p.join(destDir.path, '${newId()}${p.extension(picked.path)}');
  await File(picked.path).copy(destPath);
  return destPath;
}
