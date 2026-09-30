import 'season.dart';

abstract class SeasonRepository {
  Stream<Season?> watchActiveSeason(String farmId);

  /// Every crop on the farm, newest sowing first (all statuses).
  Stream<List<Season>> watchSeasons(String farmId);

  Stream<Season?> watchSeason(String seasonId);
  Future<void> addSeason(Season season);
  Future<void> updateStatus(String seasonId, String status);

  /// Edits the fields a farmer can change after adding a crop.
  Future<void> updateDetails(
    String seasonId, {
    String? variety,
    double? area,
    DateTime? expectedHarvestDate,
    String? notes,
  });
  Future<void> deleteSeason(String seasonId);
}
