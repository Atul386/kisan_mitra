import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/crop_info.dart';

abstract class CropLibraryRepository {
  Future<List<CropInfo>> loadCrops();
}

/// Reads the bundled JSON — works fully offline, no API needed.
class AssetCropLibraryRepository implements CropLibraryRepository {
  AssetCropLibraryRepository({AssetBundle? bundle, this.assetPath = 'assets/data/crops.json'})
      : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  final String assetPath;

  @override
  Future<List<CropInfo>> loadCrops() async {
    final raw = await _bundle.loadString(assetPath);
    return CropInfo.listFromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
