import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/movie.dart';
import '../models/movie_item.dart';
import '../network/api_exception.dart';
import '../network/api_page.dart';
import '../network/api_response.dart';
import '../network/providers.dart';

/// Read-only access to the movie catalog through the API.
class MovieRepository {
  MovieRepository(this._dio);

  final Dio _dio;

  /// Public catalog search. See `MovieSearchCriteria` on the server for the supported filters.
  Future<ApiPage<Movie>> search({
    String? q,
    String? genre,
    List<String>? genres,
    bool? free,
    bool? cinema,
    int? minYear,
    double? ratingMin,
    int? priceMinCents,
    int? priceMaxCents,
    String? excludeStatus,
    String? slugPrefix,
    String sort = 'createdAt',
    bool ascending = false,
    int page = 0,
    int size = 20,
  }) async {
    final res = await guardApi(() => _dio.get<dynamic>('/movies', queryParameters: {
          if (q != null && q.isNotEmpty) 'q': q,
          if (genre != null && genre.isNotEmpty) 'genre': genre,
          if (genres != null && genres.isNotEmpty) 'genres': genres,
          if (free != null) 'free': free,
          if (cinema != null) 'cinema': cinema,
          if (minYear != null) 'minYear': minYear,
          if (ratingMin != null) 'ratingMin': ratingMin,
          if (priceMinCents != null) 'priceMinCents': priceMinCents,
          if (priceMaxCents != null) 'priceMaxCents': priceMaxCents,
          if (excludeStatus != null) 'excludeStatus': excludeStatus,
          if (slugPrefix != null && slugPrefix.isNotEmpty) 'slugPrefix': slugPrefix,
          'sort': sort,
          'direction': ascending ? 'asc' : 'desc',
          'page': page,
          'size': size,
        }));
    return ApiPage.fromJson(res.payloadMap, Movie.fromApi);
  }

  Future<List<MovieItem>> _items(Future<ApiPage<Movie>> page) async =>
      (await page).items.map(MovieItem.fromMovie).toList();

  Future<List<MovieItem>> all({int limit = 20}) => _items(search(sort: 'year', size: limit));

  Future<List<MovieItem>> byGenre(String slugOrName, {int limit = 50}) =>
      _items(search(genre: slugOrName, sort: 'viewCount', size: limit));

  Future<List<MovieItem>> byFranchise(String franchiseId, {int limit = 30}) =>
      _items(search(slugPrefix: franchiseId, sort: 'name', ascending: true, size: limit));

  Future<List<MovieItem>> topCharts({int limit = 10}) => _items(search(sort: 'viewCount', size: limit));

  Future<List<MovieItem>> topSelling({int limit = 10}) => _items(search(sort: 'rating', size: limit));

  Future<List<MovieItem>> topFree({int limit = 10}) =>
      _items(search(free: true, sort: 'viewCount', size: limit));

  Future<List<MovieItem>> topNewReleases({int limit = 10}) => _items(search(
        minYear: DateTime.now().year - 2,
        excludeStatus: 'upcoming',
        sort: 'year',
        size: limit,
      ));

  Future<List<MovieItem>> trending({int limit = 10}) =>
      _items(search(cinema: true, sort: 'viewCount', size: limit));

  Future<List<MovieItem>> similar(String movieId, {int limit = 10}) async {
    final res = await guardApi(() => _dio.get<dynamic>('/movies/$movieId/similar', queryParameters: {'limit': limit}));
    return res.payloadList.map((e) => MovieItem.fromMovie(Movie.fromApi(Map<String, dynamic>.from(e as Map)))).toList();
  }

  /// Based on the user's favourite genres on the server; anonymous callers get the most viewed.
  Future<List<MovieItem>> recommended({int limit = 20}) async {
    final res = await guardApi(() => _dio.get<dynamic>('/movies/recommended', queryParameters: {'limit': limit}));
    return res.payloadList.map((e) => MovieItem.fromMovie(Movie.fromApi(Map<String, dynamic>.from(e as Map)))).toList();
  }

  Future<List<String>> suggest(String text, {int limit = 5}) async {
    final res = await guardApi(() => _dio.get<dynamic>('/movies/suggest', queryParameters: {'q': text, 'limit': limit}));
    return res.payloadList.map((e) => e.toString()).toList();
  }

  /// [idOrSlug] is a UUID (normal case) or a slug (deep links).
  Future<Movie?> getMovieDetail(String idOrSlug) async {
    final isId = RegExp(r'^[0-9a-fA-F-]{36}$').hasMatch(idOrSlug);
    try {
      final res = await _dio.get<dynamic>(isId ? '/movies/$idOrSlug' : '/movies/by-slug/$idOrSlug');
      return Movie.fromApi(res.payloadMap);
    } on DioException catch (e) {
      final error = ApiException.fromDio(e);
      if (error.code == 'MOVIE_NOT_FOUND' || error.statusCode == 404) return null;
      throw error;
    }
  }

  Future<MovieItem?> getById(String id) async {
    final movie = await getMovieDetail(id);
    return movie == null ? null : MovieItem.fromMovie(movie);
  }
}

final movieRepoProvider = Provider((ref) => MovieRepository(ref.watch(dioProvider)));

final moviesProvider = FutureProvider.autoDispose<List<MovieItem>>(
  (ref) => ref.watch(movieRepoProvider).all(),
);

final moviesByGenreProvider = FutureProvider.autoDispose.family<List<MovieItem>, String>(
  (ref, genre) => ref.watch(movieRepoProvider).byGenre(genre),
);
