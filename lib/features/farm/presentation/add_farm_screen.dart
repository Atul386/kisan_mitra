import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:location_picker_plus/location_picker_plus.dart' hide LocationService;
import 'package:location_picker_plus/services/location_service.dart' as picker;

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

/// Adds a farm, or edits an existing one when [farmId] is given.
class AddFarmScreen extends ConsumerStatefulWidget {
  const AddFarmScreen({this.farmId, super.key});

  final String? farmId;

  @override
  ConsumerState<AddFarmScreen> createState() => _AddFarmScreenState();
}

class _AddFarmScreenState extends ConsumerState<AddFarmScreen> {
  final _nameController = TextEditingController();
  final _areaController = TextEditingController();
  final _talukaController = TextEditingController();
  String? _nameError;
  String? _areaError;
  AreaUnit _areaUnit = AreaUnit.acre;
  String? _soilType;
  String? _irrigationType;
  String? _waterSource;
  Farm? _existing;
  double? _latitude;
  double? _longitude;
  bool _saving = false;
  bool _locating = false;

  CountryModel? _country;
  StateModel? _state;
  CityModel? _village;

  static const _soilTypes = ['black', 'red', 'alluvial', 'sandy', 'loamy', 'clay'];
  static const _irrigationTypes = ['borewell', 'canal', 'rainfed', 'drip', 'sprinkler'];
  static const _waterSources = ['well', 'borewell', 'canal', 'river', 'pond', 'rainwater'];

  bool get _editing => widget.farmId != null;

  String? get _taluka => _talukaController.text.trim().isEmpty ? null : _talukaController.text.trim();
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
  void initState() {
    super.initState();
    if (_editing) {
      _loadExisting();
    } else {
      _loadIndia();
    }
  }

  /// KisanMitra is India-only: the country is fixed, so the picker starts
  /// at State. The picker reads its initial country once, so it is only
  /// built after India has loaded.
  Future<void> _loadIndia() async {
    try {
      final countries = await picker.LocationService.instance.loadCountries(
        assetPath: 'packages/location_picker_plus/assets/country.json',
      );
      final india = countries.firstWhere((c) => c.sortName == 'IN');
      if (mounted) setState(() => _country = india);
    } catch (e, st) {
      reportError(e, st, context: 'loadIndia');
    }
  }

  Future<void> _loadExisting() async {
    final farm = await ref.read(farmRepositoryProvider).getFarm(widget.farmId!);
    if (farm == null || !mounted) return;
    setState(() {
      _existing = farm;
      _nameController.text = farm.name;
      _areaController.text = farm.area.toString();
      _talukaController.text = farm.taluka ?? '';
      _areaUnit = farm.areaUnit;
      _soilType = _soilTypes.contains(farm.soilType) ? farm.soilType : null;
      _irrigationType = _irrigationTypes.contains(farm.irrigationType) ? farm.irrigationType : null;
      _waterSource = _waterSources.contains(farm.waterSource) ? farm.waterSource : null;
      _latitude = farm.latitude;
      _longitude = farm.longitude;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _areaController.dispose();
    _talukaController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;
    // Accept "2,5" as well as "2.5" — both are common on Indian keyboards.
    final area = double.tryParse(_areaController.text.trim().replaceAll(',', '.'));
    final t = AppLocalizations.of(context)!;
    setState(() {
      _nameError = _nameController.text.trim().isEmpty ? t.requiredFieldError : null;
      _areaError = _areaController.text.trim().isEmpty
          ? t.requiredFieldError
          : (area == null || !area.isFinite || area <= 0)
              ? t.invalidAreaError
              : null;
    });
    if (_nameError != null || _areaError != null) return;

    setState(() => _saving = true);
    try {
      final existing = _existing;
      if (_editing && existing != null) {
        await ref.read(farmRepositoryProvider).updateFarm(
              Farm(
                id: existing.id,
                userId: existing.userId,
                name: _nameController.text.trim(),
                area: area!,
                areaUnit: _areaUnit,
                // Region is chosen when the farm is created; editing keeps it.
                country: existing.country,
                state: existing.state,
                district: existing.district,
                taluka: _taluka,
                village: existing.village,
                soilType: _soilType,
                irrigationType: _irrigationType,
                waterSource: _waterSource,
                latitude: _latitude,
                longitude: _longitude,
              ),
            );
        if (mounted && context.canPop()) context.pop();
        return;
      }
      await ref.read(farmRepositoryProvider).addFarm(
            Farm(
              id: newId(),
              userId: user.id,
              name: _nameController.text.trim(),
              area: area!,
              areaUnit: _areaUnit,
              country: _country?.name,
              state: _state?.name ?? user.state,
              district: user.district,
              taluka: _taluka ?? user.taluka,
              village: _village?.name,
              soilType: _soilType,
              irrigationType: _irrigationType,
              waterSource: _waterSource,
              latitude: _latitude,
              longitude: _longitude,
            ),
          );
      ref.read(analyticsServiceProvider).logEvent('farm_added');
      // During onboarding the router redirect moves the farmer on; when
      // opened from the Farm tab, close so repeat taps can't add duplicates.
      if (mounted && context.canPop()) context.pop();
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
      appBar: AppBar(title: Text(_editing ? t.editFarmTitle : t.addFarmTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: t.farmNameLabel, errorText: _nameError),
              onChanged: (_) {
                if (_nameError != null) setState(() => _nameError = null);
              },
            ),
            const SizedBox(height: 16),
            if (_editing)
              Text(
                [_existing?.village, _existing?.district, _existing?.state, _existing?.country]
                    .whereType<String>()
                    .where((x) => x.isNotEmpty)
                    .join(', '),
                style: const TextStyle(color: AppColors.textSecondary),
              )
            else if (_country == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              )
            else
            LocationPickerWidget(
              showCountry: false,
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
            TextField(
              controller: _talukaController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: t.talukaLabel),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _areaController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: t.areaLabel, errorText: _areaError),
                    onChanged: (_) {
                      if (_areaError != null) setState(() => _areaError = null);
                    },
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
            DropdownButtonFormField<String>(
              initialValue: _waterSource,
              decoration: InputDecoration(labelText: t.waterSourceLabel),
              items: _waterSources.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => setState(() => _waterSource = v),
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
              child: Text(_editing ? t.save : t.saveAndContinue),
            ),
          ],
        ),
      ),
    );
  }
}
