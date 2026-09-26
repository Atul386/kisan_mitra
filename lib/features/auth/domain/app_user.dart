class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.isGuest,
    this.phone,
    this.language,
    this.state,
    this.district,
    this.village,
  });

  final String id;
  final String name;
  final bool isGuest;
  final String? phone;
  final String? language;
  final String? state;
  final String? district;
  final String? village;

  AppUser copyWith({
    String? name,
    String? phone,
    String? language,
    String? state,
    String? district,
    String? village,
  }) {
    return AppUser(
      id: id,
      isGuest: isGuest,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      language: language ?? this.language,
      state: state ?? this.state,
      district: district ?? this.district,
      village: village ?? this.village,
    );
  }
}
