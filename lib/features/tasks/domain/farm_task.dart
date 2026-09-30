enum FarmTaskState { pending, done, skipped, snoozed }

class FarmTaskEntity {
  const FarmTaskEntity({
    required this.id,
    required this.seasonId,
    required this.title,
    required this.dueDate,
    required this.state,
  });

  final String id;
  final String seasonId;
  final String title;
  final DateTime dueDate;
  final FarmTaskState state;

  /// Pending, or reminded ("Remind Me") and now due again — the farmer can
  /// still mark it Done / Skip / Remind Me.
  bool isActionableOn(DateTime today) {
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final day = DateTime(today.year, today.month, today.day);
    return state == FarmTaskState.pending || (state == FarmTaskState.snoozed && !due.isAfter(day));
  }
}
