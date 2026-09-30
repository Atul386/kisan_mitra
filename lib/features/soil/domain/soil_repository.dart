import 'soil_report.dart';

abstract class SoilRepository {
  /// Newest test first.
  Stream<List<SoilReport>> watchReports(String farmId);
  Future<void> addReport(SoilReport report);
  Future<void> deleteReport(String id);
}
