import 'fertilizer_log.dart';

abstract class FertilizerRepository {
  Stream<List<FertilizerLogEntry>> watchLogs({required String farmId, String? seasonId});
  Future<void> addLog(FertilizerLogEntry entry);
}
