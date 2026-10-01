import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nozie_mobile/core/network/api_page.dart';
import 'package:nozie_mobile/core/network/api_response.dart';
import 'package:nozie_mobile/core/network/providers.dart';
import 'package:nozie_mobile/core/session/session_providers.dart';
import 'package:nozie_mobile/features/purchase/purchase_item.dart';
import 'package:nozie_mobile/features/purchase/transaction_item.dart';

/// Read-only view of what the user owns. Purchases are created exclusively by the server when Stripe confirms
/// a payment (webhook); the client has no way to grant itself a movie.
class PurchaseRepository {
  PurchaseRepository(this._dio);

  final Dio _dio;

  Future<ApiPage<PurchaseItem>> fetch({String? query, int page = 0, int size = 50}) async {
    final res = await guardApi(() => _dio.get<dynamic>('/users/me/purchases', queryParameters: {
          if (query != null && query.isNotEmpty) 'q': query,
          'page': page,
          'size': size,
        }));
    return ApiPage.fromJson(res.payloadMap, PurchaseItem.fromApi);
  }

  Future<Set<String>> fetchIds() async {
    final res = await guardApi(() => _dio.get<dynamic>('/users/me/purchases/ids'));
    return res.payloadList.map((e) => e.toString()).toSet();
  }

  Future<bool> isPurchased(String movieId) async => (await fetchIds()).contains(movieId);

  Future<int> getPurchaseCount() async => (await fetchIds()).length;

  /// Minimal purchase record for the detail screen, or null when not owned.
  Future<Map<String, dynamic>?> getPurchaseInfo(String movieId) async {
    if (!await isPurchased(movieId)) return null;
    return {'movieId': movieId, 'isDownloaded': true, 'isFinished': false};
  }

  Future<List<TransactionItem>> transactionsFor(String movieId) async {
    final res = await guardApi(() => _dio.get<dynamic>('/users/me/transactions', queryParameters: {'size': 50}));
    return ApiPage.fromJson(res.payloadMap, TransactionItem.fromApi)
        .items
        .where((t) => t.movieId == movieId)
        .toList();
  }
}

final purchaseRepositoryProvider = Provider((ref) => PurchaseRepository(ref.watch(dioProvider)));

final purchaseIdsProvider = FutureProvider.autoDispose<Set<String>>((ref) async {
  if (ref.watch(currentUserProvider) == null) return <String>{};
  return ref.watch(purchaseRepositoryProvider).fetchIds();
});

final purchaseProvider = FutureProvider.autoDispose<List<PurchaseItem>>((ref) async {
  if (ref.watch(currentUserProvider) == null) return const <PurchaseItem>[];
  return (await ref.watch(purchaseRepositoryProvider).fetch()).items;
});

final purchaseCountProvider = FutureProvider.autoDispose<int>(
  (ref) async => (await ref.watch(purchaseIdsProvider.future)).length,
);

/// Whether the caller owns [movieId]. Always asks the server (no shared cache), so invalidating it right
/// after a checkout reflects the purchase the webhook just recorded.
final isPurchasedProvider = FutureProvider.autoDispose.family<bool, String>((ref, movieId) async {
  if (ref.watch(currentUserProvider) == null) return false;
  return ref.watch(purchaseRepositoryProvider).isPurchased(movieId);
});

final movieTransactionsProvider = FutureProvider.autoDispose.family<List<TransactionItem>, String>(
  (ref, movieId) => ref.watch(purchaseRepositoryProvider).transactionsFor(movieId),
);

final purchaseInfoProvider = FutureProvider.autoDispose.family<Map<String, dynamic>?, String>(
  (ref, movieId) => ref.watch(purchaseRepositoryProvider).getPurchaseInfo(movieId),
);
