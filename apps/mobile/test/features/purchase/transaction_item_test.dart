import 'package:flutter_test/flutter_test.dart';
import 'package:nozie_mobile/features/purchase/models/transaction_item.dart';
import 'package:nozie_mobile/features/purchase/models/purchase_item.dart';

void main() {
  test('transaction status and amount are normalised for the existing screens', () {
    final t = TransactionItem.fromApi({
      'id': 't1',
      'movieId': 'm1',
      'amountCents': 499,
      'currency': 'USD',
      'status': 'SUCCEEDED',
      'createdAt': '2026-10-01T03:00:00Z',
      'paidAt': '2026-10-01T03:01:00Z',
    });
    expect(t.amount, 4.99);
    expect(t.currency, 'usd');
    expect(t.isSuccess, isTrue);
    expect(t.paidAt, isNotNull);
    expect(t.stripePaymentIntentId, isNull); // never exposed by the server
  });

  test('unknown or missing status counts as pending', () {
    expect(TransactionItem.fromApi({'id': 'x', 'movieId': 'm'}).isPending, isTrue);
    expect(TransactionItem.fromApi({'id': 'x', 'movieId': 'm', 'status': 'FAILED'}).isFailed, isTrue);
  });

  test('purchase item is built from the nested movie summary', () {
    final p = PurchaseItem.fromApi({
      'movie': {'id': 'm1', 'name': 'Paid', 'priceCents': 300, 'rating': 4.0, 'posterUrl': 'https://x/p.jpg'},
      'purchasedAt': '2026-10-01T03:00:00Z',
    });
    expect(p.id, 'm1');
    expect(p.title, 'Paid');
    expect(p.price, 3.0);
    expect(p.isDownloaded, isTrue);
  });
}
