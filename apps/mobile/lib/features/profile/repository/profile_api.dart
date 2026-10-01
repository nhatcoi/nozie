import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/network/api_response.dart';
import '../models/user_profile.dart';
import '../models/user_profile_api.dart';

/// The signed-in user's profile on the server (`/users/me`).
class ProfileApi {
  ProfileApi(this._dio);

  final Dio _dio;

  Future<UserProfile> fetch() async {
    final res = await guardApi(() => _dio.get<dynamic>('/users/me'));
    return UserProfileApi.fromApi(res.payloadMap);
  }

  /// Only non-empty fields are sent; the email cannot be changed here.
  Future<UserProfile> update(UserProfile profile) async {
    final res = await guardApi(() => _dio.patch<dynamic>('/users/me', data: profile.toApiPatch()));
    return UserProfileApi.fromApi(res.payloadMap);
  }

  /// The server checks the real file type and a 2 MB limit; anything else is rejected.
  Future<UserProfile> uploadAvatar(File file) async {
    final form = FormData.fromMap({'file': await MultipartFile.fromFile(file.path, filename: 'avatar')});
    final res = await guardApi(() => _dio.put<dynamic>('/users/me/avatar', data: form));
    return UserProfileApi.fromApi(res.payloadMap);
  }
}
