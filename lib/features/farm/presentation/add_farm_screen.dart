import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_picker_plus/location_picker_plus.dart' hide LocationService;

import '../../../core/analytics/analytics_providers.dart';
import '../../../core/location/location_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/error_reporter.dart';
import '../../../core/utils/ids.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/auth_providers.dart';
import '../domain/farm.dart';
import '../farm_providers.dart';
import 'widgets/farm_location_map.dart';

class AddFarmScreen extends ConsumerStatefulWidget {
  const AddFarmScreen({super.key});

  @override
  ConsumerState<AddFarmScreen> createState() => _AddFarmScreenState();
}

class _AddFarmScreenState extends ConsumerState<AddFarmScreen> {
  final _nameController = TextEditingController();
  final _areaController = TextEditingController();
  AreaUnit _areaUnit = AreaUnit.acre;
  String? _soilType;
  String? _irrigationType;
  double? _latitude;
  double? _longitude;
  bool _saving = false;
  bool _locating = false;

  CountryModel? _country;
  StateModel? _state;
  CityModel? _village;

  static const _soilTypes = ['black', 'red', 'alluvial', 'sandy', 'loamy', 'clay'];
  static const _irrigationTypes = ['borewell', 'canal', 'rainfed', 'drip', 'sprinkler'];
  final _locationService = LocationService();

  Future<void> _useCurrentLocation() async {
    setState(() => _locating = true);
    try {
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
        });
      }
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;
    final area = double.tryParse(_areaController.text.trim());
    if (_nameController.text.trim().isEmpty || area == null) return;

    setState(() => _saving = true);
    try {
      await ref.read(farmRepositoryProvider).addFarm(
            Farm(
              id: newId(),
              userId: user.id,
              name: _nameController.text.trim(),
              area: area,
              areaUnit: _areaUnit,
              country: _country?.name,
              state: _state?.name ?? user.state,
              district: user.district,
              village: _village?.name,
              soilType: _soilType,
              irrigationType: _irrigationType,
              latitude: _latitude,
              longitude: _longitude,
            ),
          );
      ref.read(analyticsServiceProvider).logEvent('farm_added');
      // Router redirect moves to Add Crop once a farm exists.
    } catch (e, st) {
      reportError(e, st, context: 'AddFarmScreen.save');
      if (mounted) showGenericErrorSnackBar(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.addFarmTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: t.farmNameLabel),
            ),
            const SizedBox(height: 16),
            LocationPickerWidget(
              // 2.x defaults to type-ahead fields; keep plain dropdowns,
              // which are easier for farmers on small screens.
              useAutocomplete: false,
              initialCountry: _country,
              initialState: _state,
              initialCity: _village,
              countryLabel: t.countryLabel,
              stateLabel: t.stateLabel,
              cityLabel: t.villageLabel,
              countryHint: t.countryLabel,
              stateHint: t.stateLabel,
              cityHint: t.villageLabel,
              spacing: const EdgeInsets.symmetric(vertical: 8),
              onCountryChanged: (c) => setState(() => _country = c),
              onStateChanged: (s) => setState(() => _state = s),
              onCityChanged: (c) => setState(() => _village = c),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _areaController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: t.areaLabel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<AreaUnit>(
                    initialValue: _areaUnit,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: t.areaUnitLabel),
                    items: AreaUnit.values
                        .map((u) => DropdownMenuItem(value: u, child: Text(u.name)))
                        .toList(),
                    onChanged: (u) => setState(() => _areaUnit = u ?? _areaUnit),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _soilType,
              decoration: InputDecoration(labelText: t.soilTypeLabel),
              items: _soilTypes.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => setState(() => _soilType = v),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _irrigationType,
              decoration: InputDecoration(labelText: t.irrigationTypeLabel),
              items:
                  _irrigationTypes.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => setState(() => _irrigationType = v),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _locating ? null : _useCurrentLocation,
              icon: Icon(_latitude != null ? Icons.check_circle_outline : Icons.my_location_outlined),
              label: Text(t.useCurrentLocation),
            ),
            if (_latitude != null && _longitude != null) ...[
              const SizedBox(height: 12),
              Text(t.farmLocationLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              FarmLocationMap(
                latitude: _latitude!,
                longitude: _longitude!,
                onMoved: (lat, lng) => setState(() {
                  _latitude = lat;
                  _longitude = lng;
                }),
              ),
              const SizedBox(height: 6),
              Text(
                t.mapTapToMovePin,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              child: Text(t.saveAndContinue),
            ),
          ],
        ),
      ),
    );
  }
}
