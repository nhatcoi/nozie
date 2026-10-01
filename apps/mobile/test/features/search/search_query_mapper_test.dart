import 'package:flutter_test/flutter_test.dart';
import 'package:nozie_mobile/features/search/filter_section.dart';
import 'package:nozie_mobile/features/search/search_query_mapper.dart';

void main() {
  test('sort options map to whitelisted API sorts', () {
    expect(SearchQueryMapper.sortFor(SortOption.trending), ('viewCount', false));
    expect(SearchQueryMapper.sortFor(SortOption.highestRating), ('rating', false));
    expect(SearchQueryMapper.sortFor(SortOption.lowestRating), ('rating', true));
    expect(SearchQueryMapper.sortFor(SortOption.lowestPrice), ('priceCents', true));
    expect(SearchQueryMapper.sortFor(SortOption.newReleases), ('year', false));
  });

  test('filter-sheet genres become catalog slugs, deduplicated, "all" ignored', () {
    expect(SearchQueryMapper.genresFor(['action', 'all']), ['hanh-dong']);
    expect(SearchQueryMapper.genresFor(['fantasy', 'scienceFiction']), ['than-thoai', 'vien-tuong', 'khoa-hoc']);
    expect(SearchQueryMapper.genresFor(['unknown-slug']), ['unknown-slug']);
    expect(SearchQueryMapper.genresFor([]), isEmpty);
  });

  test('USD prices become integer cents without float drift', () {
    expect(SearchQueryMapper.cents(4.99), 499);
    expect(SearchQueryMapper.cents(0.1 + 0.2), 30);
    expect(SearchQueryMapper.cents(null), isNull);
  });

  test('curated list labels are not treated as text queries', () {
    for (final q in ['', 'trending', 'Popular', 'best selling', 'free', 'new releases']) {
      expect(SearchQueryMapper.isPseudoQuery(q), isTrue, reason: q);
    }
    expect(SearchQueryMapper.isPseudoQuery('batman'), isFalse);
  });
}
