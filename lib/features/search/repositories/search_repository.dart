import '../entities/search_result.dart';
import '../entities/search_filter.dart';

class SearchRepository {

  static const String _imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  Future<SearchResultsPage<SearchResult>> search(
    String query, {
    SearchFilters filters = const SearchFilters(),
    int page = 1,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // delay
      
      final mockResults = _generateMockResults(query, page);
      
      return SearchResultsPage<SearchResult>(
        items: mockResults,
        page: page,
        pageSize: 20,
        total: 100,
      );
    } catch (e) {
      throw Exception('Failed to search: $e');
    }
  }

  Future<List<String>> getSuggestions(String query) async {
    try {

      await Future.delayed(const Duration(milliseconds: 200));
      
      final mockSuggestions = [
        'Avengers',
        'Avengers Endgame',
        'Avengers Infinity War',
        'Avatar',
        'Avatar: The Way of Water',
        'Black Panther',
        'Black Widow',
        'Captain America',
        'Doctor Strange',
        'Iron Man',
      ];
      
      return mockSuggestions
          .where((suggestion) => 
              suggestion.toLowerCase().contains(query.toLowerCase()))
          .take(5)
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<SearchResult>> getTrendingMovies() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return _generateMockResults('trending', 1);
    } catch (e) {
      throw Exception('Failed to get trending movies: $e');
    }
  }

  Future<List<SearchResult>> getPopularMovies() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return _generateMockResults('popular', 1);
    } catch (e) {
      throw Exception('Failed to get popular movies: $e');
    }
  }

  // mock
  List<SearchResult> _generateMockResults(String query, int page) {
    final mockMovies = [
      {
        'id': '1',
        'title': 'Avengers: Endgame',
        'subtitle': 'The Final Battle',
        'imageUrl': '$_imageBaseUrl/or06FN3Dka5tukK1e9sl16pB3iy.jpg',
        'type': SearchResultType.movie,
        'rating': 8.4,
        'ratingCount': 25000,
        'genres': ['Action', 'Adventure', 'Drama'],
        'releaseYear': '2019',
      },
      {
        'id': '2',
        'title': 'Avatar: The Way of Water',
        'subtitle': 'Return to Pandora',
        'imageUrl': '$_imageBaseUrl/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg',
        'type': SearchResultType.movie,
        'rating': 7.8,
        'ratingCount': 18000,
        'genres': ['Action', 'Adventure', 'Fantasy'],
        'releaseYear': '2022',
      },
      {
        'id': '3',
        'title': 'Black Panther: Wakanda Forever',
        'subtitle': 'The Legacy Continues',
        'imageUrl': '$_imageBaseUrl/sv1xJUazXeYqALzczSZ3O6nkH75.jpg',
        'type': SearchResultType.movie,
        'rating': 7.3,
        'ratingCount': 12000,
        'genres': ['Action', 'Adventure', 'Drama'],
        'releaseYear': '2022',
      },
      {
        'id': '4',
        'title': 'Top Gun: Maverick',
        'subtitle': 'The Need for Speed',
        'imageUrl': '$_imageBaseUrl/62HCnUTziyWcpDaBO2i1DX17ljH.jpg',
        'type': SearchResultType.movie,
        'rating': 8.3,
        'ratingCount': 22000,
        'genres': ['Action', 'Drama'],
        'releaseYear': '2022',
      },
      {
        'id': '5',
        'title': 'Spider-Man: No Way Home',
        'subtitle': 'Multiverse of Madness',
        'imageUrl': '$_imageBaseUrl/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg',
        'type': SearchResultType.movie,
        'rating': 8.2,
        'ratingCount': 20000,
        'genres': ['Action', 'Adventure', 'Fantasy'],
        'releaseYear': '2021',
      },
      {
        'id': '6',
        'title': 'The Batman',
        'subtitle': 'Dark Knight Returns',
        'imageUrl': '$_imageBaseUrl/b0PlSFdDwbyK0cf5RxwDpaOJQvQ.jpg',
        'type': SearchResultType.movie,
        'rating': 7.8,
        'ratingCount': 15000,
        'genres': ['Action', 'Crime', 'Drama'],
        'releaseYear': '2022',
      },
      {
        'id': '7',
        'title': 'Doctor Strange in the Multiverse of Madness',
        'subtitle': 'Reality Breaks',
        'imageUrl': '$_imageBaseUrl/9Gtg2DzBhmYamXBS1hKAhiwbBKS.jpg',
        'type': SearchResultType.movie,
        'rating': 6.9,
        'ratingCount': 14000,
        'genres': ['Action', 'Adventure', 'Fantasy'],
        'releaseYear': '2022',
      },
      {
        'id': '8',
        'title': 'Thor: Love and Thunder',
        'subtitle': 'God of Thunder',
        'imageUrl': '$_imageBaseUrl/pIkRyD18kl4FhoCNQuWxWu5cBLM.jpg',
        'type': SearchResultType.movie,
        'rating': 6.3,
        'ratingCount': 11000,
        'genres': ['Action', 'Adventure', 'Comedy'],
        'releaseYear': '2022',
      },
    ];


    final filteredMovies = mockMovies.where((movie) {
      final title = movie['title'] as String;
      final subtitle = movie['subtitle'] as String;
      return title.toLowerCase().contains(query.toLowerCase()) ||
             subtitle.toLowerCase().contains(query.toLowerCase());
    }).toList();

    final results = query == 'trending' || query == 'popular' 
        ? mockMovies 
        : filteredMovies.isNotEmpty 
            ? filteredMovies 
            : mockMovies.take(3).toList();

    return results.map((movie) => SearchResult(
      id: movie['id'] as String,
      title: movie['title'] as String,
      subtitle: movie['subtitle'] as String,
      imageUrl: movie['imageUrl'] as String,
      type: movie['type'] as SearchResultType,
      rating: movie['rating'] as double,
      ratingCount: movie['ratingCount'] as int,
      genres: List<String>.from(movie['genres'] as List),
      releaseYear: movie['releaseYear'] as String,
      metadata: {
        'popularity': 85.0,
        'vote_average': movie['rating'] as double,
        'vote_count': movie['ratingCount'] as int,
      },
    )).toList();
  }

}
