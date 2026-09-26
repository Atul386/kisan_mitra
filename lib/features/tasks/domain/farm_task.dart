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
}
