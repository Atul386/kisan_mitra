import 'mandi_price.dart';

/// V1 is backed by [LocalMandiRepository] — the farmer logs prices they've
/// personally observed, since a live feed needs a registered
/// data.gov.in/Agmarknet API key we don't have yet. The UI is written
/// against this abstraction so a real feed can be swapped in later
/// (blueprint §23, §35) without changing a single screen.
abstract class MandiRepository {
  Stream<List<MandiPriceEntry>> watchPrices({required String farmId, String? commodity});
  Future<void> addPrice(MandiPriceEntry entry);
}
