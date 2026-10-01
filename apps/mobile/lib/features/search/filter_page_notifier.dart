import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nozie_mobile/features/search/search_filter.dart';
import 'package:nozie_mobile/features/search/filter_section.dart';


final filterPageNotifierProvider = StateNotifierProvider<FilterPageNotifier, FilterPageState>(
      (ref) => FilterPageNotifier(),
);

class FilterPageState {
  final SearchFilters tempFilters;
  final SortOption selectedSort;
  final RatingOption selectedRating;
  final LanguageOption selectedLanguage;
  final AgeOption selectedAge;

  const FilterPageState({
    required this.tempFilters,
    required this.selectedSort,
    required this.selectedRating,
    required this.selectedLanguage,
    required this.selectedAge,
  });

  FilterPageState copyWith({
    SearchFilters? tempFilters,
    SortOption? selectedSort,
    RatingOption? selectedRating,
    LanguageOption? selectedLanguage,
    AgeOption? selectedAge,
  }) {
    return FilterPageState(
      tempFilters: tempFilters ?? this.tempFilters,
      selectedSort: selectedSort ?? this.selectedSort,
      selectedRating: selectedRating ?? this.selectedRating,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedAge: selectedAge ?? this.selectedAge,
    );
  }
}

class FilterPageNotifier extends StateNotifier<FilterPageState> {
  FilterPageNotifier() : super(_initialState);

  static const FilterPageState _initialState = FilterPageState(
    tempFilters: SearchFilters(),
    selectedSort: SortOption.trending,
    selectedRating: RatingOption.all,
    selectedLanguage: LanguageOption.all,
    selectedAge: AgeOption.all,
  );

  void initializeFromFilters(SearchFilters filters) {
    state = state.copyWith(
      tempFilters: filters,
      selectedSort: filters.sortBy,
      selectedRating: _ratingFromFilters(filters),
      selectedLanguage: filters.language,
      selectedAge: filters.age,
    );
  }

  RatingOption _ratingFromFilters(SearchFilters filters) {
    final r = filters.ratingMin ?? 0;
    if (r >= 4.5) return RatingOption.above45;
    if (r >= 4.0) return RatingOption.above40;
    return RatingOption.all;
  }

  void updateSort(SortOption sort) {
    state = state.copyWith(
      selectedSort: sort,
      tempFilters: state.tempFilters.copyWith(sortBy: sort),
    );
  }

  void updateRating(RatingOption rating) {
    final double? ratingMin = switch (rating) {
      RatingOption.all => null,
      RatingOption.above40 => 4.0,
      RatingOption.above45 => 4.5,
    };
    state = state.copyWith(
      selectedRating: rating,
      tempFilters: state.tempFilters.copyWith(ratingMin: ratingMin),
    );
  }

  void updateLanguage(LanguageOption language) {
    state = state.copyWith(
      selectedLanguage: language,
      tempFilters: state.tempFilters.copyWith(language: language),
    );
  }

  void updateAge(AgeOption age) {
    state = state.copyWith(
      selectedAge: age,
      tempFilters: state.tempFilters.copyWith(age: age),
    );
  }

  void updatePriceRange(double min, double max) {
    state = state.copyWith(
      tempFilters: state.tempFilters.copyWith(
        priceMin: min,
        priceMax: max,
      ),
    );
  }

  void updateGenres(List<String> genres) {
    state = state.copyWith(
      tempFilters: state.tempFilters.copyWith(genres: genres),
    );
  }

  void reset() {
    state = _initialState;
  }
}
