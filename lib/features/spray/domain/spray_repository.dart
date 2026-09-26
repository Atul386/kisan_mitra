import 'spray_log.dart';

abstract class SprayRepository {
  Stream<List<SprayLogEntry>> watchLogs({required String farmId, String? seasonId});
  Future<void> addLog(SprayLogEntry entry);
}
