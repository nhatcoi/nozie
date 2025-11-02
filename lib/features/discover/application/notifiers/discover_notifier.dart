import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/movie_item.dart';
import '../../data/repositories/discover_repository.dart';
import '../../domain/enums/discover_section_type.dart';

final discoverNotifierProvider = StateNotifierProvider.family<
    DiscoverSectionNotifier, AsyncValue<List<MovieItem>>, DiscoverSectionType>(
  (ref, sectionType) {
    final repository = ref.watch(discoverRepositoryProvider);
    return DiscoverSectionNotifier(repository, sectionType);
  },
);

class DiscoverSectionNotifier
    extends StateNotifier<AsyncValue<List<MovieItem>>> {
  final DiscoverRepository _repository;
  final DiscoverSectionType _sectionType;

  DiscoverSectionNotifier(this._repository, this._sectionType)
      : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final items = await _repository.getSectionItems(_sectionType);
      state = AsyncValue.data(items);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> refresh() async => _load();
}

