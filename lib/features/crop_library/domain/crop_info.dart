/// Static agronomy reference for one crop, loaded from
/// `assets/data/crops.json`. General guidance only — never dosage or
/// pesticide recommendations.
class CropInfo {
  const CropInfo({
    required this.id,
    required this.name,
    required this.icon,
    required this.overview,
    required this.sowing,
    required this.soil,
    required this.climate,
    required this.irrigation,
    required this.nutrients,
    required this.pests,
    required this.diseases,
    required this.harvest,
    required this.storage,
  });

  final String id;
  final String name;
  final String icon;
  final String overview;
  final String sowing;
  final String soil;
  final String climate;
  final String irrigation;
  final String nutrients;
  final List<String> pests;
  final List<String> diseases;
  final String harvest;
  final String storage;

  factory CropInfo.fromJson(Map<String, dynamic> json) => CropInfo(
        id: json['id'] as String,
        name: json['name'] as String,
        icon: json['icon'] as String? ?? '🌱',
        overview: json['overview'] as String? ?? '',
        sowing: json['sowing'] as String? ?? '',
        soil: json['soil'] as String? ?? '',
        climate: json['climate'] as String? ?? '',
        irrigation: json['irrigation'] as String? ?? '',
        nutrients: json['nutrients'] as String? ?? '',
        pests: (json['pests'] as List?)?.cast<String>() ?? const [],
        diseases: (json['diseases'] as List?)?.cast<String>() ?? const [],
        harvest: json['harvest'] as String? ?? '',
        storage: json['storage'] as String? ?? '',
      );

  static List<CropInfo> listFromJson(Map<String, dynamic> json) =>
      ((json['crops'] as List?) ?? const []).map((c) => CropInfo.fromJson(c as Map<String, dynamic>)).toList();

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    return q.isEmpty || name.toLowerCase().contains(q) || id.contains(q);
  }
}
