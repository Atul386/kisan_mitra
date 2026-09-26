import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());

/// Stable int id for a scheduled reminder from a string entity id — the
/// plugin's API requires an int (Android notification id).
int notificationIdFor(String entityId) => entityId.hashCode & 0x7fffffff;
