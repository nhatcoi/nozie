import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/wishlist_repository.dart';
import '../../../../core/models/movie_item.dart';

final wishlistStateProvider =
    StateNotifierProvider<WishlistStateNotifier, WishlistState>(
  (ref) => WishlistStateNotifier(),
);

enum WishlistStatus { idle, loading, success, error }

class WishlistState {
  final List<MovieItem> items;
  final WishlistStatus status;
  final String? error;

  const WishlistState({
    this.items = const [],
    this.status = WishlistStatus.idle,
    this.error,
  });

  WishlistState copyWith({
    List<MovieItem>? items,
    WishlistStatus? status,
    String? error,
  }) {
    return WishlistState(
      items: items ?? this.items,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

class WishlistStateNotifier extends StateNotifier<WishlistState> {
  WishlistStateNotifier() : super(const WishlistState()) {
    loadWishlist();
  }

  final WishlistRepository _repository = WishlistRepository();

  Future<void> loadWishlist() async {
    state = state.copyWith(status: WishlistStatus.loading);

    try {
      final items = await _repository.getWishlist();
      state = state.copyWith(
        items: items,
        status: WishlistStatus.success,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: WishlistStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> removeFromWishlist(String itemId) async {
    try {
      await _repository.removeFromWishlist(itemId);
      final updatedItems = state.items.where((item) => item.id != itemId).toList();
      state = state.copyWith(items: updatedItems);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

