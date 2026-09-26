import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_colors.dart';

/// Small OpenStreetMap preview of the farm's pin (no API key needed).
/// Tapping the map moves the pin, so a farmer standing at the gate rather
/// than in the field can still mark the right spot.
class FarmLocationMap extends StatelessWidget {
  const FarmLocationMap({
    required this.latitude,
    required this.longitude,
    this.onMoved,
    this.height = 180,
    super.key,
  });

  final double latitude;
  final double longitude;
  final void Function(double latitude, double longitude)? onMoved;
  final double height;

  @override
  Widget build(BuildContext context) {
    final point = LatLng(latitude, longitude);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: height,
        child: FlutterMap(
          // Re-centre when the pin is replaced by a fresh GPS fix.
          key: ValueKey('$latitude,$longitude'),
          options: MapOptions(
            initialCenter: point,
            initialZoom: 15,
            onTap: onMoved == null ? null : (_, p) => onMoved!(p.latitude, p.longitude),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.vishal.kisan_mitra',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: point,
                  width: 40,
                  height: 40,
                  alignment: Alignment.topCenter,
                  child: const Icon(Icons.location_on, color: AppColors.primaryDark, size: 40),
                ),
              ],
            ),
            const SimpleAttributionWidget(source: Text('OpenStreetMap contributors')),
          ],
        ),
      ),
    );
  }
}
