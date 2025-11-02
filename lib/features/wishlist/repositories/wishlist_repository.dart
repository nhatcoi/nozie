import '../../../../core/models/movie_item.dart';
import '../../../../core/utils/image_constant.dart';

class WishlistRepository {
  Future<List<MovieItem>> getWishlist() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data
    return [
      MovieItem(
        id: '1',
        title: 'Avengers: Endgame',
        imageUrl: ImageConstant.imgCard,
        rating: 8.4,
        price: 9.99,
      ),
      MovieItem(
        id: '2',
        title: 'Avatar: The Way of Water',
        imageUrl: ImageConstant.imgCard,
        rating: 7.8,
        price: 12.99,
      ),
      MovieItem(
        id: '3',
        title: 'Black Panther: Wakanda Forever',
        imageUrl: ImageConstant.imgCard,
        rating: 7.3,
        price: 10.99,
      ),
      MovieItem(
        id: '4',
        title: 'Top Gun: Maverick',
        imageUrl: ImageConstant.imgCard,
        rating: 8.3,
        price: 11.99,
      ),
      MovieItem(
        id: '5',
        title: 'Spider-Man: No Way Home',
        imageUrl: ImageConstant.imgCard,
        rating: 8.2,
        price: 9.99,
      ),
      MovieItem(
        id: '6',
        title: 'The Batman',
        imageUrl: ImageConstant.imgCard,
        rating: 7.8,
        price: 8.99,
      ),
      MovieItem(
        id: '7',
        title: 'Doctor Strange in the Multiverse of Madness',
        imageUrl: ImageConstant.imgCard,
        rating: 6.9,
        price: 10.99,
      ),
      MovieItem(
        id: '8',
        title: 'Thor: Love and Thunder',
        imageUrl: ImageConstant.imgCard,
        rating: 6.3,
        price: 9.99,
      ),
    ];
  }

  Future<void> removeFromWishlist(String itemId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock implementation - sẽ thay bằng API sau
  }
}

