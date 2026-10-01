import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nozie_mobile/core/network/api_response.dart';
import 'package:nozie_mobile/core/network/providers.dart';

/// Playback problem reports. The reporter is the signed-in user (from the access token).
class ReportService {
  ReportService(this._dio);

  final Dio _dio;

  Future<void> reportVideoIssue({
    required String movieId,
    required String issueType,
    String? description,
    String? errorMessage,
  }) async {
    String? clip(String? v, int max) {
      final t = v?.trim();
      if (t == null || t.isEmpty) return null;
      return t.length > max ? t.substring(0, max) : t;
    }

    await guardApi(() => _dio.post<dynamic>('/movies/$movieId/reports', data: {
          'issueType': issueType,
          if (clip(description, 800) != null) 'description': clip(description, 800),
          if (clip(errorMessage, 300) != null) 'errorMessage': clip(errorMessage, 300),
        }));
  }
}

final reportServiceProvider = Provider((ref) => ReportService(ref.watch(dioProvider)));
