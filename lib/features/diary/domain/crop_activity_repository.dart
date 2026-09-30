import 'crop_activity.dart';

abstract class CropActivityRepository {
  /// Newest first.
  Stream<List<CropActivity>> watchActivities(String seasonId);
  Future<CropActivity?> getActivity(String id);
  Future<void> addActivity(CropActivity activity);
  Future<void> updateActivity(CropActivity activity);
  Future<void> deleteActivity(String id);
}
