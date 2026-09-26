import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/unconfigured_ai_repository.dart';
import 'domain/ai_repository.dart';

final aiRepositoryProvider = Provider<AiRepository>((ref) => UnconfiguredAiRepository());
