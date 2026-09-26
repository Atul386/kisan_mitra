import 'irrigation_log.dart';

abstract class IrrigationRepository {
  Stream<List<IrrigationLogEntry>> watchLogs({required String farmId, String? seasonId});
  Future<void> addLog(IrrigationLogEntry entry);
}
