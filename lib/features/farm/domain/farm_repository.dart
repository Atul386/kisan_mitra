import 'farm.dart';

/// Today backed by [LocalFarmRepository] (SQLite only). A future
/// `FirebaseFarmRepository` implements this same contract so the UI
/// never changes (blueprint §35, §49).
abstract class FarmRepository {
  Stream<List<Farm>> watchFarms(String userId);
  Future<Farm?> getFarm(String farmId);
  Future<void> addFarm(Farm farm);
  Future<void> updateFarm(Farm farm);
  Future<void> deleteFarm(String farmId);
  Future<void> setLocation({required String farmId, required double latitude, required double longitude});
}
