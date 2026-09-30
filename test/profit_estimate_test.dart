import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/features/profit/domain/profit_estimate.dart';

void main() {
  test('revenue is area x yield x price, margin is revenue minus costs', () {
    final e = ProfitEstimate.calculate(
      areaAcres: 2,
      yieldPerAcreQuintal: 50,
      pricePerQuintal: 2000,
      costs: [20000, 15000, 10000],
    );
    expect(e.revenue, 200000);
    expect(e.cost, 45000);
    expect(e.margin, 155000);
    expect(e.isLoss, isFalse);
  });

  test('a loss is reported when costs exceed revenue', () {
    final e = ProfitEstimate.calculate(
      areaAcres: 1,
      yieldPerAcreQuintal: 5,
      pricePerQuintal: 1000,
      costs: [8000],
    );
    expect(e.margin, -3000);
    expect(e.isLoss, isTrue);
  });

  test('no costs entered means zero cost', () {
    final e = ProfitEstimate.calculate(areaAcres: 1, yieldPerAcreQuintal: 10, pricePerQuintal: 100);
    expect(e.cost, 0);
    expect(e.margin, 1000);
  });
}
