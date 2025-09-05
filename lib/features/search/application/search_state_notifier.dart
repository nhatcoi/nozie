import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchStateProvider = StateNotifierProvider<SearchStateNotifier, SearchState>(
      (ref) => SearchStateNotifier(),
);

class SearchState {
  final String query;
  final bool isSearching;
  final bool hasSubmitted;
  final bool hasResults;

  const SearchState({
    this.query = '',
    this.isSearching = false,
    this.hasSubmitted = false,
    this.hasResults = false,
  });

  SearchState copyWith({
    String? query,
    bool? isSearching,
    bool? hasSubmitted,
    bool? hasResults,
  }) {
    return SearchState(
      query: query ?? this.query,
      isSearching: isSearching ?? this.isSearching,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      hasResults: hasResults ?? this.hasResults,
    );
  }
}

class SearchStateNotifier extends StateNotifier<SearchState> {
  SearchStateNotifier() : super(const SearchState());

  void updateQuery(String query) {
    state = state.copyWith(
      query: query,
      isSearching: query.isNotEmpty,
      hasResults: false,
    );
  }

  void submit(String query) {
    state = state.copyWith(
      query: query,
      isSearching: true,
      hasSubmitted: true,
      hasResults: false,
    );
  }

  void clear() {
    state = const SearchState();
  }

  void setResults() {
    state = state.copyWith(
      hasResults: true,
    );
  }
}
