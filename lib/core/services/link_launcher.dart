import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens official websites, phone dialers and maps. Kept behind an
/// interface so screens (and tests) don't depend on the plugin.
abstract class LinkLauncher {
  Future<bool> openWebsite(String url);
  Future<bool> dial(String phoneNumber);
}

class UrlLauncherLinkLauncher implements LinkLauncher {
  const UrlLauncherLinkLauncher();

  @override
  Future<bool> openWebsite(String url) async {
    final uri = Uri.tryParse(url);
    // HTTPS only (blueprint §33).
    if (uri == null || uri.scheme != 'https') return false;
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> dial(String phoneNumber) async {
    try {
      return await launchUrl(Uri(scheme: 'tel', path: phoneNumber));
    } catch (_) {
      return false;
    }
  }
}

final linkLauncherProvider = Provider<LinkLauncher>((ref) => const UrlLauncherLinkLauncher());
