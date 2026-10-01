import '../entities/filter_section.dart';
import '../entities/search_filter.dart';

/// Translates the search UI's filters into catalog API query parameters.
class SearchQueryMapper {
  SearchQueryMapper._();

  /// Filter-sheet genre keys (`GenreOption.name`) to the catalog's genre slugs.
  static const genreSlugs = <String, List<String>>{
    'action': ['hanh-dong'],
    'adventure': ['phieu-luu'],
    'romance': ['tinh-cam'],
    'comics': ['hoat-hinh'],
    'comedy': ['hai-huoc'],
    'fantasy': ['than-thoai', 'vien-tuong'],
    'mystery': ['bi-an'],
    'horror': ['kinh-di'],
    'scienceFiction': ['khoa-hoc', 'vien-tuong'],
    'thriller': ['hinh-su'],
    'travel': ['phieu-luu'],
  };

  static List<String> genresFor(List<String> keys) {
    final out = <String>{};
    for (final key in keys) {
      if (key == GenreOption.all.name) continue;
      out.addAll(genreSlugs[key] ?? [key]);
    }
    return out.toList();
  }

  /// `(field, ascending)` for the API's whitelisted sort.
  static (String, bool) sortFor(SortOption option) => switch (option) {
        SortOption.trending => ('viewCount', false),
        SortOption.newReleases => ('year', false),
        SortOption.highestRating => ('rating', false),
        SortOption.lowestRating => ('rating', true),
        SortOption.highestPrice => ('priceCents', false),
        SortOption.lowestPrice => ('priceCents', true),
      };

  static int? cents(double? usd) => usd == null ? null : (usd * 100).round();

  /// Queries the UI uses as labels for curated lists; they mean "no text filter".
  static bool isPseudoQuery(String q) {
    final l = q.trim().toLowerCase();
    return l.isEmpty || l == 'trending' || l == 'popular' || l == 'best selling' || l == 'free' || l == 'new releases';
  }
}
