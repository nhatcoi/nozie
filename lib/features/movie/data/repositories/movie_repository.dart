import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/movie_data_store.dart';
import '../../../../core/models/movie_item.dart';

final movieRepositoryProvider = Provider((ref) => MovieRepository());

class MovieRepository {
  final _dataStore = MovieDataStore();

  Future<Map<String, dynamic>?> getMovieDetail(String movieId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _dataStore.getById(movieId);
  }

  Future<List<MovieItem>> getSimilarMovies(String movieId, {int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final similar = _dataStore.getSimilar(movieId, limit: limit);
    return _dataStore.toMovieItems(similar);
  }

  Future<List<MovieItem>> getSeriesMovies(String franchiseId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final series = _dataStore.getByFranchise(franchiseId);
    return _dataStore.toMovieItems(series);
  }
}

