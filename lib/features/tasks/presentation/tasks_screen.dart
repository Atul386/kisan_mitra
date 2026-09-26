import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/analytics/analytics_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/error_reporter.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/farm_task.dart';
import '../task_providers.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final tasksAsync = ref.watch(todaysTasksProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.todaysTasks)),
      body: SafeArea(
        child: tasksAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(t.genericErrorMessage, textAlign: TextAlign.center),
            ),
          ),
          data: (tasks) {
            if (tasks.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_outline, size: 48, color: AppColors.primary),
                      const SizedBox(height: 12),
                      Text(t.allTasksDoneMessage, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, i) => _TaskCard(task: tasks[i]),
            );
          },
        ),
      ),
    );
  }
}

class _TaskCard extends ConsumerWidget {
  const _TaskCard({required this.task});

  final FarmTaskEntity task;

  Future<void> _run(BuildContext context, WidgetRef ref, Future<void> Function() action) async {
    try {
      await action();
    } catch (e, st) {
      reportError(e, st, context: 'TasksScreen.action');
      if (context.mounted) showGenericErrorSnackBar(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final repo = ref.read(taskRepositoryProvider);
    final analytics = ref.read(analyticsServiceProvider);
    final isResolved = task.state != FarmTaskState.pending;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_iconFor(task.state), color: _colorFor(task.state)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      decoration: task.state == FarmTaskState.skipped
                          ? TextDecoration.lineThrough
                          : null,
                      color: isResolved ? AppColors.textSecondary : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            if (isResolved) ...[
              const SizedBox(height: 8),
              Text(_statusLabel(t, task.state), style: const TextStyle(color: AppColors.textSecondary)),
            ] else ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _run(context, ref, () async {
                        await repo.markDone(task.id);
                        analytics.logEvent('task_completed');
                      }),
                      child: Text(t.done),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _run(context, ref, () => repo.snoozeToTomorrow(task.id)),
                      child: Text(t.remindMe),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton(
                      onPressed: () => _run(context, ref, () => repo.markSkipped(task.id)),
                      child: Text(t.skip),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _iconFor(FarmTaskState state) {
    switch (state) {
      case FarmTaskState.pending:
        return Icons.radio_button_unchecked;
      case FarmTaskState.done:
        return Icons.check_circle;
      case FarmTaskState.skipped:
        return Icons.cancel_outlined;
      case FarmTaskState.snoozed:
        return Icons.notifications_active_outlined;
    }
  }

  Color _colorFor(FarmTaskState state) {
    switch (state) {
      case FarmTaskState.pending:
        return AppColors.textSecondary;
      case FarmTaskState.done:
        return AppColors.primary;
      case FarmTaskState.skipped:
        return AppColors.disabled;
      case FarmTaskState.snoozed:
        return AppColors.warning;
    }
  }

  String _statusLabel(AppLocalizations t, FarmTaskState state) {
    switch (state) {
      case FarmTaskState.done:
        return t.taskStatusDone;
      case FarmTaskState.skipped:
        return t.taskStatusSkipped;
      case FarmTaskState.snoozed:
        return t.taskStatusSnoozed;
      case FarmTaskState.pending:
        return '';
    }
  }
}
