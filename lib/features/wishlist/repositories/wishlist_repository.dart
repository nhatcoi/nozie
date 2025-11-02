import '../../../../core/models/movie_item.dart';
import '../../../../core/data/movie_data_store.dart';

class WishlistRepository {
  final _dataStore = MovieDataStore();
  final List<String> _wishlistIds = ['1', '2', '3', '4', '5', '6', '7', '8'];

  Future<List<MovieItem>> getWishlist() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final movies = _dataStore.getByIds(_wishlistIds);
    return _dataStore.toMovieItems(movies);
  }

  Future<void> removeFromWishlist(String itemId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _wishlistIds.remove(itemId);
  }
}

