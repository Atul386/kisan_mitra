import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/features/crop_library/domain/crop_info.dart';

void main() {
  final crops = CropInfo.listFromJson(
    jsonDecode(File('assets/data/crops.json').readAsStringSync()) as Map<String, dynamic>,
  );

  test('bundled library contains the ten launch crops', () {
    expect(
      crops.map((c) => c.id),
      containsAll(['onion', 'soybean', 'wheat', 'rice', 'tomato', 'cotton', 'sugarcane', 'chilli', 'potato', 'maize']),
    );
  });

  test('every crop has all sections filled in', () {
    for (final c in crops) {
      for (final text in [c.overview, c.sowing, c.soil, c.climate, c.irrigation, c.nutrients, c.harvest, c.storage]) {
        expect(text.trim(), isNotEmpty, reason: c.id);
      }
      expect(c.pests, isNotEmpty, reason: c.id);
      expect(c.diseases, isNotEmpty, reason: c.id);
    }
  });

  test('search matches by name, ignores case, and empty query matches all', () {
    expect(crops.where((c) => c.matches('ONI')).map((c) => c.id), ['onion']);
    expect(crops.where((c) => c.matches('')).length, crops.length);
    expect(crops.where((c) => c.matches('zzz')), isEmpty);
  });
}
