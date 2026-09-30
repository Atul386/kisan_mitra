import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../crop/crop_providers.dart';
import '../../dashboard/dashboard_providers.dart';
import '../domain/reminder.dart';
import '../reminder_providers.dart';
import 'reminder_labels.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final async = ref.watch(remindersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.remindersTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/reminders/add'),
        icon: const Icon(Icons.add),
        label: Text(t.reminderNew),
      ),
      body: SafeArea(
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(t.genericErrorMessage)),
          data: (all) {
            if (all.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.alarm_outlined, size: 48, color: AppColors.textSecondary),
                      const SizedBox(height: 12),
                      Text(t.remindersEmpty, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
                    ],
                  ),
                ),
              );
            }
            final pending = all.where((r) => !r.completed).toList();
            final done = all.where((r) => r.completed).toList().reversed.toList();
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                if (pending.isNotEmpty) _Header(t.remindersUpcoming),
                for (final r in pending) _ReminderTile(reminder: r),
                if (done.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _Header(t.remindersCompleted),
                  for (final r in done) _ReminderTile(reminder: r),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 4),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
      );
}

class _ReminderTile extends ConsumerWidget {
  const _ReminderTile({required this.reminder});

  final Reminder reminder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final actions = ref.read(reminderActionsProvider);
    final overdue = !reminder.completed && reminder.repeat == ReminderRepeat.none && reminder.scheduledFor.isBefore(DateTime.now());
    final when = DateFormat('d MMM, h:mm a').format(reminder.scheduledFor);
    final farm = ref.watch(primaryFarmProvider);
    final seasons = farm == null ? const [] : ref.watch(farmSeasonsProvider(farm.id)).valueOrNull ?? const [];
    final cropName = seasons.where((s) => s.id == reminder.cropId).map((s) => s.cropName).firstOrNull;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        minTileHeight: 68,
        onTap: () => context.push('/reminders/${reminder.id}/edit'),
        leading: Checkbox(
          value: reminder.completed,
          onChanged: (_) => reminder.completed ? actions.reopen(reminder) : actions.complete(reminder),
        ),
        title: Text(
          '${reminder.category.emoji}  ${reminder.title}',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            decoration: reminder.completed ? TextDecoration.lineThrough : null,
            color: reminder.completed ? AppColors.textSecondary : null,
          ),
        ),
        subtitle: Text(
          [
            when,
            if (cropName != null) cropName,
            if (!reminder.notificationEnabled) t.reminderNotifyOff,
            if (reminder.repeat != ReminderRepeat.none) t.reminderRepeatsEvery(reminderRepeatLabel(t, reminder.repeat)),
          ].join(' · '),
          style: TextStyle(color: overdue ? AppColors.error : AppColors.textSecondary),
        ),
        trailing: IconButton(
          tooltip: t.deleteButton,
          icon: const Icon(Icons.delete_outline),
          onPressed: () async {
            final ok = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                content: Text(t.reminderDeleteConfirm),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.cancel)),
                  TextButton(onPressed: () => Navigator.pop(context, true), child: Text(t.deleteButton)),
                ],
              ),
            );
            if (ok == true) await actions.delete(reminder.id);
          },
        ),
      ),
    );
  }
}
