import 'season.dart';

abstract class SeasonRepository {
  Stream<Season?> watchActiveSeason(String farmId);
  Future<void> addSeason(Season season);
  Future<void> updateStatus(String seasonId, String status);
}
