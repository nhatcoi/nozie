import '../../../../core/data/movie_data_store.dart';
import '../entities/search_result.dart';
import '../entities/search_filter.dart';
import '../entities/filter_section.dart';

class SearchRepository {
  final _dataStore = MovieDataStore();

  Future<SearchResultsPage<SearchResult>> search(
    String query, {
    SearchFilters filters = const SearchFilters(),
    int page = 1,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      List<Map<String, dynamic>> movies;
      
      if (query.isEmpty || query.toLowerCase() == 'trending' || query.toLowerCase() == 'popular') {
        movies = _dataStore.getTrending(limit: 20);
      } else {
        movies = _dataStore.search(query);
      }
      
      // Apply filters
      movies = _applyFilters(movies, filters);
      
      // Pagination
      final startIndex = (page - 1) * 20;
      final endIndex = startIndex + 20;
      final paginatedMovies = movies.skip(startIndex).take(20).toList();
      
      final results = paginatedMovies.map((movie) => _toSearchResult(movie)).toList();
      
      return SearchResultsPage<SearchResult>(
        items: results,
        page: page,
        pageSize: 20,
        total: movies.length,
      );
    } catch (e) {
      throw Exception('Failed to search: $e');
    }
  }

  Future<List<String>> getSuggestions(String query) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      
      if (query.isEmpty) return [];
      
      final allMovies = _dataStore.getAll();
      final suggestions = allMovies
          .where((movie) {
            final title = (movie['title'] as String).toLowerCase();
            return title.contains(query.toLowerCase());
          })
          .map((movie) => movie['title'] as String)
          .toSet()
          .toList();
      
      return suggestions.take(5).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<SearchResult>> getTrendingMovies() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final movies = _dataStore.getTrending(limit: 8);
      return movies.map((movie) => _toSearchResult(movie)).toList();
    } catch (e) {
      throw Exception('Failed to get trending movies: $e');
    }
  }

  Future<List<SearchResult>> getPopularMovies() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final movies = _dataStore.getTopCharts(limit: 8);
      return movies.map((movie) => _toSearchResult(movie)).toList();
    } catch (e) {
      throw Exception('Failed to get popular movies: $e');
    }
  }

  List<Map<String, dynamic>> _applyFilters(
    List<Map<String, dynamic>> movies,
    SearchFilters filters,
  ) {
    var filtered = List<Map<String, dynamic>>.from(movies);
    
    // Filter by price
    if (filters.priceMin != null || filters.priceMax != null) {
      filtered = filtered.where((movie) {
        final price = movie['price'] as double?;
        if (price == null) return filters.priceMax == 0.0;
        if (filters.priceMin != null && price < filters.priceMin!) return false;
        if (filters.priceMax != null && price > filters.priceMax!) return false;
        return true;
      }).toList();
    }
    
    // Filter by rating
    if (filters.ratingMin != null) {
      filtered = filtered.where((movie) {
        final rating = movie['rating'] as double;
        return rating >= filters.ratingMin!;
      }).toList();
    }
    
    // Filter by genres
    if (filters.genres.isNotEmpty) {
      filtered = filtered.where((movie) {
        final movieGenres = (movie['genres'] as List<dynamic>)
            .map((g) => g.toString().toLowerCase())
            .toList();
        return filters.genres.any((genre) => movieGenres.contains(genre.toLowerCase()));
      }).toList();
    }
    
    // Sort
    switch (filters.sortBy) {
      case SortOption.trending:
        filtered.sort((a, b) {
          final aTrending = (a['isTrending'] as bool) ? 1 : 0;
          final bTrending = (b['isTrending'] as bool) ? 1 : 0;
          if (aTrending != bTrending) return bTrending.compareTo(aTrending);
          return (b['rating'] as double).compareTo(a['rating'] as double);
        });
        break;
      case SortOption.highestRating:
        filtered.sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
        break;
      case SortOption.lowestRating:
        filtered.sort((a, b) => (a['rating'] as double).compareTo(b['rating'] as double));
        break;
      case SortOption.lowestPrice:
        filtered.sort((a, b) {
          final aPrice = a['price'] as double? ?? double.infinity;
          final bPrice = b['price'] as double? ?? double.infinity;
          return aPrice.compareTo(bPrice);
        });
        break;
      case SortOption.highestPrice:
        filtered.sort((a, b) {
          final aPrice = a['price'] as double? ?? 0.0;
          final bPrice = b['price'] as double? ?? 0.0;
          return bPrice.compareTo(aPrice);
        });
        break;
      case SortOption.newReleases:
        filtered.sort((a, b) {
          final aNew = (a['isNew'] as bool) ? 1 : 0;
          final bNew = (b['isNew'] as bool) ? 1 : 0;
          if (aNew != bNew) return bNew.compareTo(aNew);
          try {
            final aDate = DateTime.parse(_extractDate(a['releaseDate'] as String));
            final bDate = DateTime.parse(_extractDate(b['releaseDate'] as String));
            return bDate.compareTo(aDate);
          } catch (e) {
            return 0;
          }
        });
        break;
    }
    
    return filtered;
  }

  SearchResult _toSearchResult(Map<String, dynamic> movie) {
    final releaseDate = movie['releaseDate'] as String;
    final releaseYear = releaseDate.split(',').last.trim();
    
    return SearchResult(
      id: movie['id'] as String,
      title: movie['title'] as String,
      subtitle: movie['subtitle'] as String?,
      imageUrl: movie['imageUrl'] as String,
      type: SearchResultType.movie,
      rating: movie['rating'] as double,
      ratingCount: movie['ratingCount'] as int,
      genres: List<String>.from(movie['genres'] as List),
      releaseYear: releaseYear,
      metadata: {
        'popularity': (movie['views'] as String).replaceAll('M+', '').replaceAll('K+', ''),
        'vote_average': movie['rating'] as double,
        'vote_count': movie['ratingCount'] as int,
      },
    );
  }

  String _extractDate(String dateString) {
    final parts = dateString.split(',');
    if (parts.length == 2) {
      final monthDay = parts[0].trim().split(' ');
      final month = _monthToNumber(monthDay[0]);
      final day = monthDay[1];
      final year = parts[1].trim();
      return '$year-$month-$day';
    }
    return '2023-01-01';
  }

  String _monthToNumber(String month) {
    const months = {
      'January': '01', 'February': '02', 'March': '03', 'April': '04',
      'May': '05', 'June': '06', 'July': '07', 'August': '08',
      'September': '09', 'October': '10', 'November': '11', 'December': '12',
    };
    return months[month] ?? '01';
  }
}
