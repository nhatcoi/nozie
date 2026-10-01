import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nozie_mobile/core/models/movie_item.dart';
import 'package:nozie_mobile/core/repositories/movie_repository.dart';
import 'package:nozie_mobile/features/discover/discover_section_type.dart';

final discoverSectionProvider = FutureProvider.autoDispose.family<List<MovieItem>, DiscoverSectionType>(
  (ref, sectionType) {
    final repo = ref.watch(movieRepoProvider);
    switch (sectionType) {
      case DiscoverSectionType.topCharts:
        return repo.topCharts(limit: 5);
      case DiscoverSectionType.topSelling:
        return repo.topSelling(limit: 4);
      case DiscoverSectionType.topFree:
        return repo.topFree(limit: 4);
      case DiscoverSectionType.topNewReleases:
        return repo.topNewReleases(limit: 4);
    }
  },
);
