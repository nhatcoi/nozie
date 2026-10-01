import 'package:flutter_test/flutter_test.dart';
import 'package:nozie_mobile/core/models/movie.dart';
import 'package:nozie_mobile/core/models/movie_item.dart';
import 'package:nozie_mobile/core/network/api_page.dart';

void main() {
  const detail = {
    'id': '11111111-1111-1111-1111-111111111111',
    'slug': 'phim-hay',
    'name': 'Phim Hay',
    'originName': 'Great Movie',
    'type': 'single',
    'year': 2021,
    'viewCount': 1500,
    'rating': 4.2,
    'ratingCount': 80,
    'priceCents': 499,
    'duration': '120 phút',
    'cinema': true,
    'directors': ['A'],
    'genres': [
      {'id': 1, 'slug': 'hanh-dong', 'name': 'Hành Động'},
    ],
    'countries': [
      {'name': 'Mỹ'},
    ],
  };

  test('maps API detail JSON onto the shapes the UI already reads', () {
    final m = Movie.fromApi(Map<String, dynamic>.from(detail));
    expect(m.id, '11111111-1111-1111-1111-111111111111');
    expect(m.title, 'Phim Hay');
    expect(m.time, '120 phút');
    expect(m.view, 1500);
    expect(m.chieurap, true);
    expect(m.rating, closeTo(4.2, 1e-9)); // 0-5 in, read back as 0-5 via tmdb.vote_average / 2
    expect(m.ratingCount, 80);
    expect(m.priceUsd, 4.99);
    expect(m.priceValue, 4.99);
    expect(m.price!['vnd'], (4.99 * 23000).round());
    expect(m.genres, ['Hành Động']);
    expect(m.episodes, isNull); // stream URLs never travel with catalog data
  });

  test('summary genres are plain names and unrated movies have no rating', () {
    final m = Movie.fromApi({'id': 'x', 'name': 'N', 'genres': ['Drama', 'Action'], 'priceCents': 0});
    expect(m.genres, ['Drama', 'Action']);
    expect(m.rating, isNull);
    expect(m.priceValue, 0.0);
  });

  test('MovieItem carries genres, year and counts for search results', () {
    final item = MovieItem.fromMovie(Movie.fromApi(Map<String, dynamic>.from(detail)));
    expect(item.genres, ['Hành Động']);
    expect(item.year, 2021);
    expect(item.ratingCount, 80);
    expect(item.price, 4.99);
  });

  test('ApiPage parses the envelope payload and reports whether another page exists', () {
    final page = ApiPage<String>.fromJson(
      {'items': [{'id': 'a'}, {'id': 'b'}], 'page': 0, 'size': 2, 'totalItems': 5, 'totalPages': 3},
      (j) => j['id'] as String,
    );
    expect(page.items, ['a', 'b']);
    expect(page.hasNext, isTrue);
    expect(page.map((s) => s.toUpperCase()).items, ['A', 'B']);
    final last = ApiPage<String>.fromJson({'items': [], 'page': 2, 'size': 2, 'totalItems': 5, 'totalPages': 3}, (j) => '');
    expect(last.hasNext, isFalse);
  });
}
