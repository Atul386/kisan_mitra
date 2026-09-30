import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/core/database/app_database.dart' show AppDatabase;
import 'package:kisan_mitra/core/sync/sync_queue_repository.dart';
import 'package:kisan_mitra/features/documents/data/local_document_repository.dart';
import 'package:kisan_mitra/features/documents/domain/farm_document.dart';
import 'package:kisan_mitra/features/farm/data/local_farm_repository.dart';
import 'package:kisan_mitra/features/farm/domain/farm.dart';
import 'package:kisan_mitra/features/soil/data/local_soil_repository.dart';
import 'package:kisan_mitra/features/soil/domain/soil_report.dart';

void main() {
  late AppDatabase db;
  late SyncQueueRepository queue;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    queue = SyncQueueRepository(db);
  });

  tearDown(() => db.close());

  group('farms', () {
    Farm farm(String id, String name, {String? water}) => Farm(
          id: id,
          userId: 'u1',
          name: name,
          area: 5,
          areaUnit: AreaUnit.acre,
          state: 'Maharashtra',
          waterSource: water,
        );

    test('a farmer can have several farms', () async {
      final repo = LocalFarmRepository(db, queue);
      await repo.addFarm(farm('f1', 'Home field', water: 'well'));
      await repo.addFarm(farm('f2', 'River plot'));
      final farms = await repo.watchFarms('u1').first;
      expect(farms.map((f) => f.name), unorderedEquals(['Home field', 'River plot']));
      expect(farms.firstWhere((f) => f.id == 'f1').waterSource, 'well');
    });

    test('editing a farm keeps its location and updates the rest', () async {
      final repo = LocalFarmRepository(db, queue);
      await repo.addFarm(Farm(
        id: 'f1',
        userId: 'u1',
        name: 'Home field',
        area: 5,
        areaUnit: AreaUnit.acre,
        latitude: 19.99,
        longitude: 73.78,
      ));
      await repo.updateFarm(Farm(
        id: 'f1',
        userId: 'u1',
        name: 'Home field (north)',
        area: 6.5,
        areaUnit: AreaUnit.hectare,
        waterSource: 'canal',
        latitude: 19.99,
        longitude: 73.78,
      ));
      final f = (await repo.getFarm('f1'))!;
      expect(f.name, 'Home field (north)');
      expect(f.area, 6.5);
      expect(f.areaUnit, AreaUnit.hectare);
      expect(f.waterSource, 'canal');
      expect(f.latitude, 19.99);
    });

    test('deleting a farm removes it from the list', () async {
      final repo = LocalFarmRepository(db, queue);
      await repo.addFarm(farm('f1', 'Home field'));
      await repo.addFarm(farm('f2', 'River plot'));
      await repo.deleteFarm('f1');
      expect((await repo.watchFarms('u1').first).map((f) => f.id), ['f2']);
    });
  });

  group('document locker rules', () {
    test('accepts PDF, JPG and PNG case-insensitively', () {
      expect(DocumentRules.mimeTypeFor('7-12.PDF'), 'application/pdf');
      expect(DocumentRules.mimeTypeFor('card.jpg'), 'image/jpeg');
      expect(DocumentRules.mimeTypeFor('card.JPEG'), 'image/jpeg');
      expect(DocumentRules.mimeTypeFor('scan.png'), 'image/png');
    });

    test('rejects other types, empty files and files over 10 MB', () {
      expect(DocumentRules.check('virus.exe', 100), DocumentRejection.unsupportedType);
      expect(DocumentRules.check('notes.docx', 100), DocumentRejection.unsupportedType);
      expect(DocumentRules.check('noextension', 100), DocumentRejection.unsupportedType);
      expect(DocumentRules.check('a.pdf', 0), DocumentRejection.empty);
      expect(DocumentRules.check('a.pdf', DocumentRules.maxBytes + 1), DocumentRejection.tooLarge);
      expect(DocumentRules.check('a.pdf', DocumentRules.maxBytes), isNull);
      expect(DocumentRules.check('a.pdf', 1234), isNull);
    });

    test('the size limit matches storage.rules (10 MB)', () {
      expect(DocumentRules.maxBytes, 10 * 1024 * 1024);
    });
  });

  group('document repository', () {
    FarmDocument doc(String id, DocumentCategory c, DateTime at) => FarmDocument(
          id: id,
          category: c,
          title: 'Doc $id',
          localPath: '/tmp/$id.pdf',
          mimeType: 'application/pdf',
          sizeBytes: 100,
          createdAt: at,
        );

    test('stores, lists newest first, records backup and deletes', () async {
      final repo = LocalDocumentRepository(db, queue);
      await repo.addDocument(doc('d1', DocumentCategory.extract712, DateTime(2026, 9, 1)));
      await Future<void>.delayed(const Duration(milliseconds: 5));
      await repo.addDocument(doc('d2', DocumentCategory.cropInsurance, DateTime(2026, 9, 2)));

      var list = await repo.watchDocuments().first;
      expect(list.map((d) => d.id), ['d2', 'd1']);
      expect(list.first.category, DocumentCategory.cropInsurance);
      expect(list.first.isBackedUp, isFalse);

      await repo.setCloudPath('d2', 'users/u1/documents/d2.pdf');
      expect((await repo.getDocument('d2'))!.isBackedUp, isTrue);

      await repo.deleteDocument('d1');
      list = await repo.watchDocuments().first;
      expect(list.map((d) => d.id), ['d2']);
    });
  });

  group('soil', () {
    test('values must be plausible; blank is allowed; commas work as decimals', () {
      expect(SoilLimits.ph.parse('6.5').value, 6.5);
      expect(SoilLimits.ph.parse('6,5').value, 6.5);
      expect(SoilLimits.ph.parse('').value, isNull);
      expect(SoilLimits.ph.parse('').isInvalid, isFalse);
      expect(SoilLimits.ph.parse('65').isInvalid, isTrue, reason: 'typo for 6.5');
      expect(SoilLimits.ph.parse('-1').isInvalid, isTrue);
      expect(SoilLimits.ph.parse('abc').isInvalid, isTrue);
      expect(SoilLimits.organicCarbonPercent.parse('0.62').value, 0.62);
      expect(SoilLimits.organicCarbonPercent.parse('25').isInvalid, isTrue);
      expect(SoilLimits.nutrientKgPerHa.parse('280').value, 280);
    });

    test('a report needs at least one value', () {
      final empty = SoilReport(id: 'r', farmId: 'f1', date: DateTime(2026, 9, 1));
      expect(empty.hasValues, isFalse);
      expect(SoilReport(id: 'r', farmId: 'f1', date: DateTime(2026, 9, 1), ph: 6.8).hasValues, isTrue);
    });

    test('reports are kept per farm, newest first, and can be deleted', () async {
      final repo = LocalSoilRepository(db, queue);
      await repo.addReport(SoilReport(id: 'r1', farmId: 'f1', date: DateTime(2026, 3, 1), ph: 6.5, nitrogen: 210));
      await repo.addReport(SoilReport(
        id: 'r2',
        farmId: 'f1',
        date: DateTime(2026, 9, 1),
        ph: 7.1,
        organicCarbon: 0.55,
        otherNutrients: 'Zinc 0.6 ppm',
      ));
      await repo.addReport(SoilReport(id: 'r3', farmId: 'f2', date: DateTime(2026, 9, 2), ph: 5.9));

      final list = await repo.watchReports('f1').first;
      expect(list.map((r) => r.id), ['r2', 'r1']);
      expect(list.first.otherNutrients, 'Zinc 0.6 ppm');
      expect(list.last.nitrogen, 210);

      await repo.deleteReport('r2');
      expect((await repo.watchReports('f1').first).map((r) => r.id), ['r1']);
    });
  });
}
