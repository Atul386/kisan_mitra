import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/crop_library_repository.dart';
import 'domain/crop_info.dart';

final cropLibraryRepositoryProvider = Provider<CropLibraryRepository>((ref) => AssetCropLibraryRepository());

final cropLibraryProvider = FutureProvider<List<CropInfo>>((ref) => ref.watch(cropLibraryRepositoryProvider).loadCrops());

final cropSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredCropsProvider = Provider<AsyncValue<List<CropInfo>>>((ref) {
  final query = ref.watch(cropSearchQueryProvider);
  return ref.watch(cropLibraryProvider).whenData((crops) => crops.where((c) => c.matches(query)).toList());
});
