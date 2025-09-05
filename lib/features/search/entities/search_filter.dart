class SearchFilters {
  final SortOption sortBy;
  final double? priceMin;
  final double? priceMax;
  final double? ratingMin;
  final List<String> genres;
  final LanguageOption language;
  final AgeOption age;

  const SearchFilters({
    this.sortBy = SortOption.trending,
    this.priceMin,
    this.priceMax,
    this.ratingMin,
    this.genres = const [],
    this.language = LanguageOption.all,
    this.age = AgeOption.all,
  });
}

enum SortOption {
  trending,
  newReleases,
  highestRating,
  lowestRating,
  highestPrice,
  lowestPrice,
}

enum LanguageOption {
  all,
  english,
  mandarin,
  other,
}

enum AgeOption {
  all,
  under12,
}
