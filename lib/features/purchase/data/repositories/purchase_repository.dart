import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/movie_data_store.dart';
import '../../models/purchase_item.dart';

final purchaseRepositoryProvider = Provider((ref) => PurchaseRepository());

class PurchaseRepository {
  final _dataStore = MovieDataStore();
  final List<String> _purchasedIds = ['9', '10', '11', '12', '13', '14', '15'];
  final Map<String, Map<String, bool>> _purchaseStatus = {
    '9': {'isDownloaded': true, 'isFinished': true},
    '10': {'isDownloaded': true, 'isFinished': true},
    '11': {'isDownloaded': false, 'isFinished': false},
    '12': {'isDownloaded': true, 'isFinished': true},
    '13': {'isDownloaded': true, 'isFinished': true},
    '14': {'isDownloaded': true, 'isFinished': false},
    '15': {'isDownloaded': true, 'isFinished': true},
  };

  Future<List<PurchaseItem>> getPurchasedItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final movies = _dataStore.getByIds(_purchasedIds);
    return movies.map((movie) {
      final status = _purchaseStatus[movie['id']] ?? {'isDownloaded': false, 'isFinished': false};
      final baseItem = _dataStore.toMovieItem(movie);
      return PurchaseItem(
        id: baseItem.id,
        title: baseItem.title,
        imageUrl: baseItem.imageUrl,
        rating: baseItem.rating,
        price: baseItem.price,
        isDownloaded: status['isDownloaded'] ?? false,
        isFinished: status['isFinished'] ?? false,
      );
    }).toList();
  }

  Future<void> removeDownload(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (_purchaseStatus.containsKey(id)) {
      _purchaseStatus[id] = {
        'isDownloaded': false,
        'isFinished': _purchaseStatus[id]!['isFinished'] ?? false,
      };
    }
  }

  Future<void> markAsFinished(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (_purchaseStatus.containsKey(id)) {
      _purchaseStatus[id] = {
        'isDownloaded': _purchaseStatus[id]!['isDownloaded'] ?? false,
        'isFinished': true,
      };
    }
  }
}

