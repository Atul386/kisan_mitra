import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/features/advisories/data/advisory_content.dart';
import 'package:kisan_mitra/features/nearby/domain/nearby_category.dart';

void main() {
  group('nearbySearchUri', () {
    test('searches around the farm when coordinates exist', () {
      final uri = nearbySearchUri(NearbyCategory.soilLab, latitude: 19.99, longitude: 73.78);
      expect(uri.host, 'www.google.com');
      expect(uri.queryParameters['query'], 'soil testing laboratory near 19.99,73.78');
    });

    test('falls back to the phone location without coordinates', () {
      final uri = nearbySearchUri(NearbyCategory.bank);
      expect(uri.queryParameters['query'], 'bank near me');
    });
  });

  group('official content', () {
    test('every scheme and service link is HTTPS', () {
      final urls = [
        ...kSchemes.map((s) => s.officialUrl),
        ...[...kPmKisanServices, ...kInsuranceServices].map((s) => s.url).whereType<String>(),
      ];
      expect(urls, isNotEmpty);
      for (final u in urls) {
        expect(Uri.parse(u).scheme, 'https', reason: u);
      }
    });

    test('every service has a link or a helpline', () {
      for (final s in [...kPmKisanServices, ...kInsuranceServices]) {
        expect(s.url != null || s.phone != null, isTrue, reason: s.title);
      }
    });

    test('scheme ids are unique', () {
      final ids = kSchemes.map((s) => s.id).toList();
      expect(ids.toSet().length, ids.length);
    });
  });
}
