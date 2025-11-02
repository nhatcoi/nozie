import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/movie_item.dart';
import '../../../../core/utils/image_constant.dart';
import '../../domain/enums/discover_section_type.dart';

final discoverRepositoryProvider = Provider((ref) => DiscoverRepository());

class DiscoverRepository {
  Future<List<MovieItem>> getSectionItems(DiscoverSectionType sectionType) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _getMockDataForSection(sectionType);
  }

  List<MovieItem> _getMockDataForSection(DiscoverSectionType sectionType) {
    switch (sectionType) {
      case DiscoverSectionType.topCharts:
        return [
          MovieItem(
            id: '1',
            title: 'Harry Potter and the Deathly Hallows',
            imageUrl: ImageConstant.imgCard,
            rating: 4.7,
            price: 9.99,
          ),
          MovieItem(
            id: '2',
            title: 'A Court of Thorns & Roses Book 1',
            imageUrl: ImageConstant.imgCard,
            rating: 4.6,
            price: 6.50,
          ),
          MovieItem(
            id: '3',
            title: 'The Batman Who Laughs: Issues 1-7',
            imageUrl: ImageConstant.imgCard,
            rating: 4.3,
            price: 10.44,
          ),
          MovieItem(
            id: '4',
            title: 'Game of Thrones: A Song of Ice & Fire',
            imageUrl: ImageConstant.imgCard,
            rating: 4.4,
            price: 7.79,
          ),
          MovieItem(
            id: '5',
            title: 'Song of Silver, Flame Like Night',
            imageUrl: ImageConstant.imgCard,
            rating: 4.0,
            price: 10.00,
          ),
        ];
      case DiscoverSectionType.topSelling:
        return [
          MovieItem(
            id: '6',
            title: 'The Batman Who Laughs: Issues 1-7',
            imageUrl: ImageConstant.imgCard,
            rating: 4.3,
            price: 10.44,
          ),
          MovieItem(
            id: '7',
            title: 'Game of Thrones: A Song of Ice & Fire',
            imageUrl: ImageConstant.imgCard,
            rating: 4.4,
            price: 7.79,
          ),
          MovieItem(
            id: '8',
            title: 'Harry Potter and the Deathly Hallows',
            imageUrl: ImageConstant.imgCard,
            rating: 4.7,
            price: 9.99,
          ),
          MovieItem(
            id: '9',
            title: 'A Court of Thorns & Roses Book 1',
            imageUrl: ImageConstant.imgCard,
            rating: 4.6,
            price: 6.50,
          ),
        ];
      case DiscoverSectionType.topFree:
        return [
          MovieItem(
            id: '10',
            title: 'Alpha Magic: Reverse Harem Paranormal',
            imageUrl: ImageConstant.imgCard,
            rating: 4.4,
          ),
          MovieItem(
            id: '11',
            title: 'Taken by the Dragon King: Dragon Shifter',
            imageUrl: ImageConstant.imgCard,
            rating: 4.6,
          ),
          MovieItem(
            id: '12',
            title: 'Free Book Series: Complete Collection',
            imageUrl: ImageConstant.imgCard,
            rating: 4.2,
          ),
          MovieItem(
            id: '13',
            title: 'Indie Author Freebie: First Book',
            imageUrl: ImageConstant.imgCard,
            rating: 4.5,
          ),
        ];
      case DiscoverSectionType.topNewReleases:
        return [
          MovieItem(
            id: '14',
            title: 'Song of Silver, Flame Like Night',
            imageUrl: ImageConstant.imgCard,
            rating: 4.0,
            price: 10.00,
          ),
          MovieItem(
            id: '15',
            title: 'Son of the Poison Rose: A Kagen a Da',
            imageUrl: ImageConstant.imgCard,
            rating: 4.0,
            price: 9.00,
          ),
          MovieItem(
            id: '16',
            title: 'The New Fantasy Epic: Book One',
            imageUrl: ImageConstant.imgCard,
            rating: 4.3,
            price: 11.99,
          ),
          MovieItem(
            id: '17',
            title: 'Latest Mystery Thriller: Unraveled',
            imageUrl: ImageConstant.imgCard,
            rating: 4.1,
            price: 8.99,
          ),
        ];
    }
  }
}

