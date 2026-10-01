import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nozie_mobile/core/models/movie_item.dart';
import 'package:nozie_mobile/core/network/api_response.dart';
import 'package:nozie_mobile/core/network/providers.dart';
import 'package:nozie_mobile/core/repositories/movie_repository.dart';
import 'package:nozie_mobile/core/session/session_providers.dart';
import 'package:nozie_mobile/features/movie/movie_watch_service.dart';
import 'package:nozie_mobile/features/purchase/purchase_repository.dart';
import 'package:nozie_mobile/features/wishlist/wishlist_repository.dart';

export 'package:nozie_mobile/core/session/session_providers.dart' show currentUserProvider;

/// Names of the genres the user picked at signup (server: `GET /users/me/favorite-genres`).
final preferredGenresProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  if (ref.watch(currentUserProvider) == null) return const <String>[];
  final res = await guardApi(() => ref.watch(dioProvider).get<dynamic>('/users/me/favorite-genres'));
  return res.payloadList.map((g) => (g as Map)['name'].toString()).toList();
});

/// Recommended on the server from the user's favourite genres, falling back to the most viewed.
final recommendedMoviesProvider = FutureProvider.autoDispose<List<MovieItem>>((ref) {
  ref.watch(currentUserProvider);
  return ref.watch(movieRepoProvider).recommended();
});

final purchasedMoviesProvider = FutureProvider.autoDispose<List<MovieItem>>(
  (ref) async => List<MovieItem>.from(await ref.watch(purchaseProvider.future)),
);

final wishlistMoviesProvider = wishlistProvider;

final recentMoviesProvider = FutureProvider.autoDispose<List<MovieItem>>((ref) async {
  if (ref.watch(currentUserProvider) == null) return const <MovieItem>[];
  return ref.watch(movieWatchServiceProvider).recent();
});
