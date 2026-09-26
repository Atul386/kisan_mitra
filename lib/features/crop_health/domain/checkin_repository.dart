import 'daily_checkin.dart';

abstract class CheckinRepository {
  /// Null if the farmer hasn't checked in yet today.
  Stream<DailyCheckin?> watchTodayCheckin(String farmId);

  /// Upserts — checking in again the same day corrects the earlier entry
  /// rather than creating a duplicate.
  Future<void> saveCheckin(DailyCheckin checkin);
}
