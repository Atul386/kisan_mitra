import 'sync_handler.dart';
import 'sync_queue_repository.dart';

/// Drains the outbox (blueprint §8). With no [SyncHandler]s registered —
/// the case until a Firebase project exists — every item is simply left
/// queued: this is the honest state ("saved locally, not yet synced"),
/// not a failure. Register handlers keyed by table name once real
/// `Firebase*Repository` implementations exist; nothing else about this
/// class needs to change.
class SyncEngine {
  SyncEngine(this._queue, {Map<String, SyncHandler> handlers = const {}}) : _handlers = handlers;

  final SyncQueueRepository _queue;
  final Map<String, SyncHandler> _handlers;
  bool _draining = false;

  static const _maxAttemptsBeforeGivingUp = 5;

  /// Safe to call repeatedly (e.g. on every connectivity change) — a
  /// drain already in progress is not restarted.
  Future<void> drain() async {
    if (_draining) return;
    if (_handlers.isEmpty) return; // nothing registered yet — nothing to attempt
    _draining = true;
    try {
      while (true) {
        final batch = await _queue.nextBatch();
        if (batch.isEmpty) return;

        var processedAny = false;
        for (final item in batch) {
          final handler = _handlers[item.entityTable];
          if (handler == null) continue; // no handler for this table yet

          try {
            await handler.push(entityId: item.entityId, operation: item.operation);
            await _queue.remove(item.queueId);
            processedAny = true;
          } catch (e) {
            await _queue.recordFailure(item.queueId, e.toString());
            if (item.retryCount + 1 >= _maxAttemptsBeforeGivingUp) {
              // Give up on this one item so a single bad record can't
              // block the rest of the queue forever; it stays
              // `pendingX` on its source row for a human to notice.
              await _queue.remove(item.queueId);
            }
          }
        }
        if (!processedAny) return; // avoid spinning on unhandled/failing items
      }
    } finally {
      _draining = false;
    }
  }
}
