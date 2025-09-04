import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchStateProvider = StateNotifierProvider<SearchStateNotifier, SearchState>(
  (ref) => SearchStateNotifier(),
);

class SearchState {
  final String query;
  final bool isSearching;
  final bool hasSubmitted;
  
  const SearchState({
    this.query = '',
    this.isSearching = false,
    this.hasSubmitted = false,
  });
  
  SearchState copyWith({
    String? query,
    bool? isSearching,
    bool? hasSubmitted,
  }) {
    return SearchState(
      query: query ?? this.query,
      isSearching: isSearching ?? this.isSearching,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
    );
  }
}

class SearchStateNotifier extends StateNotifier<SearchState> {
  SearchStateNotifier() : super(const SearchState());
  
  void updateQuery(String query) {
    state = state.copyWith(
      query: query,
      isSearching: query.isNotEmpty,
    );
  }
  
  void submit(String query) {
    state = state.copyWith(
      query: query,
      isSearching: true,
      hasSubmitted: true,
    );
  }
  
  void clear() {
    state = const SearchState();
  }
}
