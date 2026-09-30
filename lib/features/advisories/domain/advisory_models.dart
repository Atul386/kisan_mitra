/// A government scheme shown in the app. Content is informational and
/// points to the official portal — eligibility is never decided here.
class Scheme {
  const Scheme({
    required this.id,
    required this.name,
    required this.overview,
    required this.eligibility,
    required this.benefits,
    required this.documents,
    required this.officialUrl,
  });

  final String id;
  final String name;
  final String overview;
  final List<String> eligibility;
  final List<String> benefits;
  final List<String> documents;
  final String officialUrl;
}

/// One official link or helpline the farmer can open.
class OfficialService {
  const OfficialService({required this.title, required this.description, this.url, this.phone});

  final String title;
  final String description;
  final String? url;
  final String? phone;
}
