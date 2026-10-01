import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nozie_mobile/core/models/movie_item.dart';
import 'package:nozie_mobile/core/network/api_page.dart';
import 'package:nozie_mobile/core/repositories/movie_repository.dart';
import 'package:nozie_mobile/features/purchase/purchase_repository.dart';
import 'package:nozie_mobile/features/wishlist/wishlist_repository.dart';
import 'package:nozie_mobile/features/search/filter_section.dart';
import 'package:nozie_mobile/features/search/search_filter.dart';
import 'package:nozie_mobile/features/search/search_result.dart';
import 'package:nozie_mobile/features/search/search_mapper.dart';
import 'package:nozie_mobile/features/search/search_screen.dart';
import 'package:nozie_mobile/features/search/search_query_mapper.dart';

final searchRepositoryProvider = Provider((ref) => SearchRepository(
      ref.watch(movieRepoProvider),
      ref.watch(wishlistRepositoryProvider),
      ref.watch(purchaseRepositoryProvider),
    ));

/// All filtering, sorting and paging happens on the server; this only translates the UI's filters.
class SearchRepository {
  SearchRepository(this._movies, this._wishlist, this._purchases);

  static const pageSize = 10;

  final MovieRepository _movies;
  final WishlistRepository _wishlist;
  final PurchaseRepository _purchases;

  /// [page] is 1-based (the UI's convention); the API is 0-based.
  Future<SearchResultsPage<SearchResult>> search(
    String query, {
    SearchFilters filters = const SearchFilters(),
    int page = 1,
    SearchSource source = SearchSource.all,
  }) async {
    final text = SearchQueryMapper.isPseudoQuery(query) ? null : query.trim();
    final apiPage = page - 1;

    final ApiPage<MovieItem> result;
    switch (source) {
      case SearchSource.wishlist:
        result = await _wishlist.fetch(query: text, page: apiPage, size: pageSize);
      case SearchSource.purchase:
        result = (await _purchases.fetch(query: text, page: apiPage, size: pageSize)).map<MovieItem>((p) => p);
      case SearchSource.all:
        result = await _catalog(text, filters, apiPage);
    }

    return SearchResultsPage<SearchResult>(
      items: result.items.map(SearchMapper.movieItemToSearchResult).toList(),
      page: page,
      pageSize: pageSize,
      total: result.totalItems,
      hasNext: result.hasNext,
    );
  }

  Future<ApiPage<MovieItem>> _catalog(String? text, SearchFilters f, int page) async {
    final (sort, ascending) = SearchQueryMapper.sortFor(f.sortBy);
    final genres = SearchQueryMapper.genresFor(f.genres);
    final result = await _movies.search(
      q: text,
      genres: genres,
      ratingMin: f.ratingMin,
      priceMinCents: SearchQueryMapper.cents(f.priceMin),
      priceMaxCents: SearchQueryMapper.cents(f.priceMax),
      minYear: f.sortBy == SortOption.newReleases ? DateTime.now().year - 2 : null,
      excludeStatus: f.sortBy == SortOption.newReleases ? 'upcoming' : null,
      sort: sort,
      ascending: ascending,
      page: page,
      size: pageSize,
    );
    return result.map<MovieItem>(MovieItem.fromMovie);
  }

  Future<List<String>> getSuggestions(String query) async {
    if (query.trim().isEmpty) return [];
    try {
      return await _movies.suggest(query.trim());
    } catch (_) {
      return [];
    }
  }

  Future<List<SearchResult>> getTrendingMovies() async =>
      (await _movies.topCharts(limit: 8)).map(SearchMapper.movieItemToSearchResult).toList();

  Future<List<SearchResult>> getPopularMovies() => getTrendingMovies();
}
