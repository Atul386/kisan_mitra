import '../domain/task_template.dart';
import 'local_task_templates.dart';

/// Deterministic task generation (blueprint §16, §46, §47): crop + crop
/// stage (approximated here by days since sowing) + template rules ->
/// today's farm plan. No AI involved — this must work even if AI/network
/// is unavailable.
class TaskRuleEngine {
  const TaskRuleEngine([this._templates = kLocalTaskTemplates]);

  final List<TaskTemplate> _templates;

  /// Returns the templates that apply to [cropId] on day [day] since
  /// sowing, with a crop-specific template taking priority over a generic
  /// one that would otherwise produce the identical task text.
  List<TaskTemplate> templatesForDay({required String cropId, required int day}) {
    final matches = _templates.where((t) => t.appliesTo(cropId: cropId, day: day)).toList()
      // Crop-specific templates first so they win the dedupe pass below.
      ..sort((a, b) => (a.cropId == null ? 1 : 0).compareTo(b.cropId == null ? 1 : 0));

    final seenTitles = <String>{};
    final result = <TaskTemplate>[];
    for (final template in matches) {
      final title = template.titleFor('en');
      if (seenTitles.add(title)) result.add(template);
    }
    return result;
  }
}
