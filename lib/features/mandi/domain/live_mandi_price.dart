/// One row from the government's Agmarknet daily mandi price feed
/// (data.gov.in resource 9ef84268-d588-465a-a308-a864a43d0070) — distinct
/// from [MandiPriceEntry], which is a price the farmer personally logged.
class LiveMandiPrice {
  const LiveMandiPrice({
    required this.state,
    required this.district,
    required this.market,
    required this.commodity,
    required this.variety,
    required this.arrivalDate,
    required this.minPrice,
    required this.maxPrice,
    required this.modalPrice,
  });

  final String state;
  final String district;
  final String market;
  final String commodity;
  final String variety;
  final String arrivalDate;
  final double minPrice;
  final double maxPrice;
  final double modalPrice;
}
