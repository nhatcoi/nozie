import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nozie_mobile/core/models/movie_item.dart';
import 'package:nozie_mobile/core/models/movie.dart';
import 'package:nozie_mobile/core/repositories/movie_repository.dart';

final movieDetailProvider = FutureProvider.autoDispose.family<Movie?, String>(
  (ref, movieId) => ref.watch(movieRepoProvider).getMovieDetail(movieId),
);

final similarMoviesProvider = FutureProvider.autoDispose.family<List<MovieItem>, String>(
  (ref, movieId) => ref.watch(movieRepoProvider).similar(movieId),
);

final seriesMoviesProvider = FutureProvider.autoDispose.family<List<MovieItem>, String>(
  (ref, franchiseId) => ref.watch(movieRepoProvider).byFranchise(franchiseId),
);
