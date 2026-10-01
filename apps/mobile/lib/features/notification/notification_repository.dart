import 'package:dio/dio.dart';

import 'package:nozie_mobile/core/network/api_page.dart';
import 'package:nozie_mobile/core/network/api_response.dart';
import 'package:nozie_mobile/features/notification/notification_item.dart';

/// The user's inbox. Notifications are created by the server (e.g. when a payment succeeds), never by the app.
class NotificationRepository {
  NotificationRepository(this._dio);

  final Dio _dio;

  Future<List<NotificationItem>> fetchNotifications({int limit = 50}) async {
    final res = await guardApi(() => _dio.get<dynamic>('/users/me/notifications', queryParameters: {'size': limit}));
    return ApiPage.fromJson(res.payloadMap, NotificationItem.fromJson).items;
  }

  Future<void> markAsRead(String notificationId) async {
    await guardApi(() => _dio.patch<dynamic>('/users/me/notifications/$notificationId/read'));
  }

  Future<void> markAllAsRead() async {
    await guardApi(() => _dio.post<dynamic>('/users/me/notifications/read-all'));
  }

  Future<int> getUnreadCount() async {
    final res = await guardApi(() => _dio.get<dynamic>('/users/me/notifications/unread-count'));
    return (res.payloadMap['count'] as num?)?.toInt() ?? 0;
  }
}
