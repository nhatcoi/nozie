import 'package:flutter_test/flutter_test.dart';
import 'package:nozie_mobile/features/notification/notification_item.dart';

void main() {
  test('parses an API notification, including the read flag', () {
    final n = NotificationItem.fromJson({
      'id': 'n1',
      'type': 'purchase',
      'title': 'Purchase successful',
      'description': 'Added to your library',
      'deepLink': 'movie:abc',
      'metadata': {'movieId': 'abc'},
      'read': false,
      'createdAt': '2026-10-01T03:00:00Z',
    });
    expect(n.type, NotificationType.purchase);
    expect(n.isRead, isFalse);
    expect(n.metadata!['movieId'], 'abc');
    expect(NotificationItem.fromJson({'id': 'n2', 'read': true, 'createdAt': '2026-10-01T03:00:00Z'}).isRead, isTrue);
  });

  test('unknown types fall back to general and bad dates do not crash', () {
    final n = NotificationItem.fromJson({'id': 'n3', 'type': 'brand-new', 'createdAt': 'garbage'});
    expect(n.type, NotificationType.general);
    expect(n.createdAt, isNotNull);
  });
}
