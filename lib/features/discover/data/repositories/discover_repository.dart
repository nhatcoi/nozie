import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/movie_item.dart';
import '../../../../core/data/movie_data_store.dart';
import '../../domain/enums/discover_section_type.dart';

final discoverRepositoryProvider = Provider((ref) => DiscoverRepository());

class DiscoverRepository {
  final _dataStore = MovieDataStore();

  Future<List<MovieItem>> getSectionItems(DiscoverSectionType sectionType) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    List<Map<String, dynamic>> movies;
    switch (sectionType) {
      case DiscoverSectionType.topCharts:
        movies = _dataStore.getTopCharts(limit: 5);
        break;
      case DiscoverSectionType.topSelling:
        movies = _dataStore.getTopSelling(limit: 4);
        break;
      case DiscoverSectionType.topFree:
        movies = _dataStore.getTopFree(limit: 4);
        break;
      case DiscoverSectionType.topNewReleases:
        movies = _dataStore.getTopNewReleases(limit: 4);
        break;
    }
    
    return _dataStore.toMovieItems(movies);
  }
}

