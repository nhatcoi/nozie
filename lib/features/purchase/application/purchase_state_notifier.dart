import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/purchase_item.dart';
import '../data/repositories/purchase_repository.dart';

final purchaseStateProvider =
    StateNotifierProvider<PurchaseStateNotifier, PurchaseState>(
  (ref) => PurchaseStateNotifier(ref.read(purchaseRepositoryProvider)),
);

enum PurchaseStatus { idle, loading, success, error }

class PurchaseState {
  final List<PurchaseItem> items;
  final PurchaseStatus status;
  final String? error;

  const PurchaseState({
    this.items = const [],
    this.status = PurchaseStatus.idle,
    this.error,
  });

  PurchaseState copyWith({
    List<PurchaseItem>? items,
    PurchaseStatus? status,
    String? error,
  }) {
    return PurchaseState(
      items: items ?? this.items,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

class PurchaseStateNotifier extends StateNotifier<PurchaseState> {
  final PurchaseRepository _repository;

  PurchaseStateNotifier(this._repository) : super(const PurchaseState()) {
    loadPurchasedItems();
  }

  Future<void> loadPurchasedItems() async {
    state = state.copyWith(status: PurchaseStatus.loading);
    try {
      final items = await _repository.getPurchasedItems();
      state = state.copyWith(items: items, status: PurchaseStatus.success);
    } catch (e) {
      state = state.copyWith(status: PurchaseStatus.error, error: e.toString());
    }
  }

  Future<void> removeDownload(String id) async {
    try {
      await _repository.removeDownload(id);
      state = state.copyWith(
        items: state.items.map((item) {
          if (item.id == id) {
            return item.copyWith(isDownloaded: false);
          }
          return item;
        }).toList(),
      );
    } catch (e) {
      state = state.copyWith(status: PurchaseStatus.error, error: e.toString());
    }
  }

  Future<void> markAsFinished(String id) async {
    try {
      await _repository.markAsFinished(id);
      state = state.copyWith(
        items: state.items.map((item) {
          if (item.id == id) {
            return item.copyWith(isFinished: true);
          }
          return item;
        }).toList(),
      );
    } catch (e) {
      state = state.copyWith(status: PurchaseStatus.error, error: e.toString());
    }
  }
}

