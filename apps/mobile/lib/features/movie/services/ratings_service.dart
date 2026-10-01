import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_response.dart';
import '../../../core/network/providers.dart';
import '../data/repositories/movie_repository.dart';

/// Viewer reviews for a movie, through the API. Who the reviewer is always comes from the access token.
class RatingsService {
  RatingsService(this._dio, {void Function(String movieId)? onChanged}) : _onChanged = onChanged;

  final Dio _dio;
  final void Function(String movieId)? _onChanged;

  Future<void> submitReview({
    required String movieId,
    required int rating,
    String? comment,
  }) async {
    if (rating < 1 || rating > 5) {
      throw ArgumentError('Rating must be between 1 and 5');
    }
    await guardApi(() => _dio.put<dynamic>('/movies/$movieId/reviews/me', data: {
          'rating': rating,
          if (comment != null && comment.trim().isNotEmpty) 'review': comment.trim(),
        }));
    _onChanged?.call(movieId);
  }

  Future<void> deleteMyReview(String movieId) async {
    await guardApi(() => _dio.delete<dynamic>('/movies/$movieId/reviews/me'));
    _onChanged?.call(movieId);
  }

  /// Likes are explicit (not a toggle on the server) so a double tap can never flip the wrong way.
  Future<void> setLike({required String movieId, required String reviewUserId, required bool liked}) async {
    final path = '/movies/$movieId/reviews/$reviewUserId/like';
    await guardApi(() => liked ? _dio.put<dynamic>(path) : _dio.delete<dynamic>(path));
    _onChanged?.call(movieId);
  }

  /// `{ averageRating, totalReviews, starsCount: {'1'..'5'} }`.
  Future<Map<String, dynamic>> fetchSummary(String movieId) async {
    final res = await guardApi(() => _dio.get<dynamic>('/movies/$movieId/reviews/summary'));
    final data = res.payloadMap;
    final distribution = Map<String, dynamic>.from((data['distribution'] as Map?) ?? const {});
    return {
      'averageRating': (data['average'] as num?)?.toDouble() ?? 0.0,
      'totalReviews': (data['count'] as num?)?.toInt() ?? 0,
      'starsCount': {for (final e in distribution.entries) e.key.toString(): (e.value as num).toInt()},
    };
  }

  /// Newest first. Each item: `userId, userName, userAvatar, rating, comment, likes, likedByMe, updatedAt`.
  Future<List<Map<String, dynamic>>> fetchReviews(String movieId, {int size = 50}) async {
    final res = await guardApi(() => _dio.get<dynamic>('/movies/$movieId/reviews', queryParameters: {'size': size}));
    final items = (res.payloadMap['items'] as List?) ?? const [];
    return items.map<Map<String, dynamic>>((raw) {
      final r = Map<String, dynamic>.from(raw as Map);
      return {
        'userId': r['userId'],
        'userName': r['userName'],
        'userAvatar': r['avatarUrl'],
        'rating': r['rating'],
        'comment': r['review'],
        'likes': r['likes'],
        'likedByMe': r['likedByMe'] == true,
        'updatedAt': r['updatedAt'] is String ? DateTime.tryParse(r['updatedAt'] as String)?.toLocal() : null,
      };
    }).toList();
  }
}

final ratingsServiceProvider = Provider<RatingsService>((ref) => RatingsService(
      ref.watch(dioProvider),
      // A new/changed review or like refreshes the summary, the list and the movie's own rating.
      onChanged: (movieId) {
        ref.invalidate(ratingDocProvider(movieId));
        ref.invalidate(reviewsProvider(movieId));
        ref.invalidate(movieDetailProvider(movieId));
      },
    ));

final AutoDisposeFutureProviderFamily<Map<String, dynamic>?, String> ratingDocProvider =
    FutureProvider.autoDispose.family<Map<String, dynamic>?, String>(
  (ref, movieId) => ref.watch(ratingsServiceProvider).fetchSummary(movieId),
);

final AutoDisposeFutureProviderFamily<List<Map<String, dynamic>>, String> reviewsProvider =
    FutureProvider.autoDispose.family<List<Map<String, dynamic>>, String>(
  (ref, movieId) => ref.watch(ratingsServiceProvider).fetchReviews(movieId),
);

/// Whether the caller liked a given review, taken from the already-loaded review list.
final reviewLikeStatusProvider = FutureProvider.autoDispose.family<bool, Map<String, String>>((ref, params) async {
  final reviews = await ref.watch(reviewsProvider(params['movieId']!).future);
  return reviews.any((r) => r['userId'] == params['reviewUserId'] && r['likedByMe'] == true);
});
