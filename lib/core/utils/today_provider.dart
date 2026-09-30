import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

DateTime _today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

/// Today's date (midnight). Providers that depend on "today" — task
/// generation, today's tasks, today's check-in — watch this so they move to
/// the new day at midnight, and when the app is reopened on a later day
/// after sitting in memory overnight ([refresh] runs on app resume).
class TodayController extends Notifier<DateTime> {
  Timer? _midnightTimer;

  @override
  DateTime build() {
    ref.onDispose(() => _midnightTimer?.cancel());
    final today = _today();
    _scheduleMidnight(today);
    return today;
  }

  void refresh() {
    final today = _today();
    if (today != state) {
      state = today;
      _scheduleMidnight(today);
    }
  }

  void _scheduleMidnight(DateTime today) {
    _midnightTimer?.cancel();
    final nextMidnight = today.add(const Duration(days: 1));
    _midnightTimer = Timer(nextMidnight.difference(DateTime.now()) + const Duration(seconds: 1), refresh);
  }
}

final todayProvider = NotifierProvider<TodayController, DateTime>(TodayController.new);
