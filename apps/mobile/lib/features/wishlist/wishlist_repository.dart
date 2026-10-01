import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nozie_mobile/core/models/movie.dart';
import 'package:nozie_mobile/core/models/movie_item.dart';
import 'package:nozie_mobile/core/network/api_page.dart';
import 'package:nozie_mobile/core/network/api_response.dart';
import 'package:nozie_mobile/core/network/providers.dart';
import 'package:nozie_mobile/core/session/session_providers.dart';

class WishlistRepository {
  WishlistRepository(this._dio, {void Function()? onChanged}) : _onChanged = onChanged;

  final Dio _dio;
  final void Function()? _onChanged;

  Future<ApiPage<MovieItem>> fetch({String? query, int page = 0, int size = 50}) async {
    final res = await guardApi(() => _dio.get<dynamic>('/users/me/wishlist', queryParameters: {
          if (query != null && query.isNotEmpty) 'q': query,
          'page': page,
          'size': size,
        }));
    return ApiPage.fromJson(res.payloadMap, (j) => MovieItem.fromMovie(Movie.fromApi(j)));
  }

  Future<Set<String>> fetchIds() async {
    final res = await guardApi(() => _dio.get<dynamic>('/users/me/wishlist/ids'));
    return res.payloadList.map((e) => e.toString()).toSet();
  }

  Future<void> addToWishlist(String movieId) async {
    await guardApi(() => _dio.put<dynamic>('/users/me/wishlist/$movieId'));
    _onChanged?.call();
  }

  Future<void> removeFromWishlist(String movieId) async {
    await guardApi(() => _dio.delete<dynamic>('/users/me/wishlist/$movieId'));
    _onChanged?.call();
  }

  Future<bool> isInWishlist(String movieId) async => (await fetchIds()).contains(movieId);

  Future<void> toggleWishlist(String movieId) async {
    if (await isInWishlist(movieId)) {
      await removeFromWishlist(movieId);
    } else {
      await addToWishlist(movieId);
    }
  }

  Future<int> getWishlistCount() async => (await fetchIds()).length;
}

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) => WishlistRepository(
      ref.watch(dioProvider),
      // Mutations refresh every view of the wishlist.
      onChanged: () {
        ref.invalidate(wishlistIdsProvider);
        ref.invalidate(wishlistProvider);
      },
    ));

/// Movie ids in the caller's wishlist; empty when signed out.
final AutoDisposeFutureProvider<Set<String>> wishlistIdsProvider = FutureProvider.autoDispose<Set<String>>((ref) async {
  if (ref.watch(currentUserProvider) == null) return <String>{};
  return ref.watch(wishlistRepositoryProvider).fetchIds();
});

final AutoDisposeFutureProvider<List<MovieItem>> wishlistProvider = FutureProvider.autoDispose<List<MovieItem>>((ref) async {
  if (ref.watch(currentUserProvider) == null) return const <MovieItem>[];
  return (await ref.watch(wishlistRepositoryProvider).fetch()).items;
});

final wishlistCountProvider = FutureProvider.autoDispose<int>(
  (ref) async => (await ref.watch(wishlistIdsProvider.future)).length,
);

final isInWishlistProvider = FutureProvider.autoDispose.family<bool, String>(
  (ref, movieId) async => (await ref.watch(wishlistIdsProvider.future)).contains(movieId),
);
