import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/movie_item.dart';
import '../../data/repositories/movie_repository.dart';

final movieDetailProvider = FutureProvider.family<Map<String, dynamic>?, String>(
  (ref, movieId) async {
    final repository = ref.watch(movieRepositoryProvider);
    return repository.getMovieDetail(movieId);
  },
);

final similarMoviesProvider = FutureProvider.family<List<MovieItem>, String>(
  (ref, movieId) async {
    final repository = ref.watch(movieRepositoryProvider);
    return repository.getSimilarMovies(movieId);
  },
);

final seriesMoviesProvider = FutureProvider.family<List<MovieItem>, String>(
  (ref, franchiseId) async {
    final repository = ref.watch(movieRepositoryProvider);
    return repository.getSeriesMovies(franchiseId);
  },
);

