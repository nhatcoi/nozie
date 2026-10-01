import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nozie_mobile/core/models/movie.dart';
import 'package:nozie_mobile/core/models/movie_item.dart';
import 'package:nozie_mobile/core/network/api_page.dart';
import 'package:nozie_mobile/core/network/api_response.dart';
import 'package:nozie_mobile/core/network/providers.dart';

/// Where to stream a movie from. Only the server hands these out, and only after checking the caller
/// owns the movie (or it is free).
class StreamInfo {
  const StreamInfo({this.streamUrl, this.embedUrl});

  final String? streamUrl;
  final String? embedUrl;

  bool get isEmpty => (streamUrl == null || streamUrl!.isEmpty) && (embedUrl == null || embedUrl!.isEmpty);
}

class MovieWatchService {
  MovieWatchService(this._dio);

  final Dio _dio;

  /// Free movies and purchased ones are watchable. Errors count as "no access" (never fail open).
  Future<bool> hasAccess(String movieId) async {
    try {
      final res = await _dio.get<dynamic>('/playback/$movieId/access');
      return res.payloadMap['canWatch'] == true;
    } catch (_) {
      return false;
    }
  }

  /// Resolving a stream also counts one view on the server.
  Future<StreamInfo> resolveStream(String movieId, {String? episodeId}) async {
    final res = await guardApi(() => _dio.get<dynamic>('/playback/$movieId',
        queryParameters: {if (episodeId != null) 'episodeId': episodeId}));
    final data = res.payloadMap;
    return StreamInfo(streamUrl: data['streamUrl'] as String?, embedUrl: data['embedUrl'] as String?);
  }

  Future<void> addWatchHistory(
    String movieId, {
    String? episodeId,
    int positionSeconds = 0,
    int durationSeconds = 0,
  }) async {
    try {
      await _dio.put<dynamic>('/users/me/watch-history/$movieId', data: {
        if (episodeId != null) 'episodeId': episodeId,
        'positionSeconds': positionSeconds.clamp(0, 86400),
        'durationSeconds': durationSeconds.clamp(0, 86400),
      });
    } catch (_) {
      // History is a convenience; never interrupt playback for it.
    }
  }

  Future<List<MovieItem>> recent({int limit = 20}) async {
    final res = await guardApi(() => _dio.get<dynamic>('/users/me/watch-history', queryParameters: {'size': limit}));
    return ApiPage.fromJson(
      res.payloadMap,
      (j) => MovieItem.fromMovie(Movie.fromApi(Map<String, dynamic>.from(j['movie'] as Map))),
    ).items;
  }
}

final movieWatchServiceProvider = Provider((ref) => MovieWatchService(ref.watch(dioProvider)));
