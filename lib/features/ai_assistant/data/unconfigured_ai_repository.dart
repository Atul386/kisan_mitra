import '../domain/ai_repository.dart';

/// Placeholder until `core/firebase/README.md`'s Cloud Function step is
/// done — see blueprint §24 for why the real call must go through a
/// callable Cloud Function rather than straight from the app.
class UnconfiguredAiRepository implements AiRepository {
  @override
  Future<String> ask({required String question, required String languageCode}) async {
    throw const AiNotConfiguredException();
  }
}
