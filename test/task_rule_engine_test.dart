import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/features/tasks/data/task_rule_engine.dart';

void main() {
  const engine = TaskRuleEngine();

  test('day 5 gets the generic germination task', () {
    final templates = engine.templatesForDay(cropId: 'wheat', day: 5);
    expect(templates.map((t) => t.id), contains('generic_germination'));
  });

  test('soybean day 25 does not show the duplicate leaf-inspection task twice', () {
    final templates = engine.templatesForDay(cropId: 'soybean', day: 25);
    final titles = templates.map((t) => t.titleFor('en')).toList();
    expect(titles.toSet().length, titles.length, reason: 'no duplicate task text on the same day');
    expect(titles, contains('Inspect leaves for pest damage'));
  });

  test('other crops still get the generic leaf-inspection task on day 25', () {
    final templates = engine.templatesForDay(cropId: 'wheat', day: 25);
    expect(templates.map((t) => t.id), contains('generic_leaf_inspection'));
  });

  test('day far beyond any template range returns nothing', () {
    final templates = engine.templatesForDay(cropId: 'soybean', day: 500);
    expect(templates, isEmpty);
  });
}
