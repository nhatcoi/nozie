import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nozie_mobile/core/network/providers.dart';
import 'package:nozie_mobile/core/session/session_providers.dart';
import 'package:nozie_mobile/features/notification/notification_item.dart';
import 'package:nozie_mobile/features/notification/notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.watch(dioProvider));
});

final notificationsProvider = FutureProvider.autoDispose<List<NotificationItem>>((ref) async {
  if (ref.watch(currentUserProvider) == null) return const <NotificationItem>[];
  return ref.watch(notificationRepositoryProvider).fetchNotifications();
});

/// Polls the unread badge once a minute while something is listening. Failures keep the last known value.
final unreadCountProvider = StreamProvider.autoDispose<int>((ref) async* {
  if (ref.watch(currentUserProvider) == null) {
    yield 0;
    return;
  }
  final repo = ref.watch(notificationRepositoryProvider);
  var last = 0;
  while (true) {
    try {
      last = await repo.getUnreadCount();
    } catch (_) {}
    yield last;
    await Future<void>.delayed(const Duration(seconds: 60));
  }
});

final hasUnreadNotificationsProvider = Provider<bool>((ref) {
  final unreadCount = ref.watch(unreadCountProvider);
  final count = unreadCount.value;
  if (count == null) return false;
  return count > 0;
});
