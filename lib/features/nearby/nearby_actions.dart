import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/link_launcher.dart';
import '../../l10n/app_localizations.dart';
import '../dashboard/dashboard_providers.dart';
import 'domain/nearby_category.dart';

/// Opens the maps app searching for [category] around the farm (or around
/// the phone if the farm has no saved location). Shows a message if the
/// link can't be opened.
Future<void> openNearby(BuildContext context, WidgetRef ref, NearbyCategory category) async {
  final t = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);
  final farm = ref.read(primaryFarmProvider);
  final uri = nearbySearchUri(category, latitude: farm?.latitude, longitude: farm?.longitude);
  final ok = await ref.read(linkLauncherProvider).openWebsite(uri.toString());
  if (!ok) messenger.showSnackBar(SnackBar(content: Text(t.couldNotOpenLink)));
}
