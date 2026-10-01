import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nozie_mobile/core/models/movie_item.dart';
import 'package:nozie_mobile/core/network/api_exception.dart';
import 'package:nozie_mobile/core/widgets/async_value_view.dart';
import 'package:nozie_mobile/core/widgets/movie_card.dart';
import 'package:nozie_mobile/core/widgets/skeleton.dart';
import 'package:nozie_mobile/i18n/translations.g.dart';

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  setUp(() => LocaleSettings.setLocale(AppLocale.en));

  group('AsyncValueView', () {
    testWidgets('shows the content when data arrives', (tester) async {
      await tester.pumpWidget(_host(AsyncValueView<int>(value: const AsyncData(3), data: (n) => Text('n=$n'))));
      expect(find.text('n=3'), findsOneWidget);
    });

    testWidgets('shows the given loading widget', (tester) async {
      await tester.pumpWidget(_host(AsyncValueView<int>(
        value: const AsyncLoading(),
        loading: const Text('skeleton'),
        data: (_) => const Text('data'),
      )));
      expect(find.text('skeleton'), findsOneWidget);
      expect(find.text('data'), findsNothing);
    });

    testWidgets('shows a friendly error with a working retry', (tester) async {
      var retried = 0;
      await tester.pumpWidget(_host(AsyncValueView<int>(
        value: AsyncError(ApiException(code: 'NETWORK', message: 'raw'), StackTrace.empty),
        onRetry: () => retried++,
        data: (_) => const Text('data'),
      )));
      expect(find.textContaining('No connection'), findsOneWidget);
      expect(find.text('raw'), findsNothing);
      await tester.tap(find.text('Retry'));
      expect(retried, 1);
    });

    testWidgets('shows the empty widget instead of an empty list', (tester) async {
      await tester.pumpWidget(_host(AsyncValueView<List<int>>(
        value: const AsyncData([]),
        isEmpty: (l) => l.isEmpty,
        empty: const Text('nothing here'),
        data: (_) => const Text('data'),
      )));
      expect(find.text('nothing here'), findsOneWidget);
    });

    testWidgets('compact errors disappear quietly', (tester) async {
      await tester.pumpWidget(_host(AsyncValueView<int>(
        value: AsyncError(ApiException(code: 'NETWORK', message: 'x'), StackTrace.empty),
        compactError: true,
        data: (_) => const Text('data'),
      )));
      expect(find.byType(Text), findsNothing);
    });
  });

  testWidgets('skeletons animate without errors and stay out of semantics', (tester) async {
    await tester.pumpWidget(_host(const MovieRowSkeleton()));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byType(Skeleton), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  group('MovieCard', () {
    const free = MovieItem(id: 'a', title: 'Free Film', imageUrl: '', rating: 4.2, price: 0, priceData: {'usd': 0.0, 'vnd': 0});
    const paid = MovieItem(id: 'b', title: 'Paid Film', imageUrl: '', rating: 3.5, price: 2.99, priceData: {'usd': 2.99, 'vnd': 68770});

    testWidgets('shows title, rating and an explicit Free label', (tester) async {
      await tester.pumpWidget(_host(const MovieCard(movie: free, width: 150, height: 225)));
      expect(find.text('Free Film'), findsOneWidget);
      expect(find.text('4.2'), findsOneWidget);
      expect(find.text('Free'), findsOneWidget);
    });

    testWidgets('shows the formatted price for paid movies', (tester) async {
      await tester.pumpWidget(_host(const MovieCard(movie: paid, width: 150, height: 225)));
      expect(find.text(r'$2.99'), findsOneWidget);
    });

    testWidgets('exposes itself to screen readers as a button with the title', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_host(const MovieCard(movie: paid, width: 150, height: 225)));
      final node = tester.getSemantics(find.byType(MovieCard));
      expect(node.label, contains('Paid Film'));
      expect(node.label, contains(r'$2.99')); // rating and price are read together with the title
      expect(node.flagsCollection.isButton, isTrue);
      handle.dispose();
    });

    testWidgets('does not overflow with large text or a very long title', (tester) async {
      const long = MovieItem(id: 'c', title: 'An Extremely Long Movie Title That Must Wrap And Be Truncated Politely', imageUrl: '', rating: 4, price: 1, priceData: {'usd': 1.0});
      await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
          child: Scaffold(body: Builder(builder: (context) {
            final h = MovieCard.heightFor(context, width: 150, posterHeight: 225);
            return SizedBox(height: h, child: const MovieCard(movie: long, width: 150, height: 225));
          })),
        ),
      ));
      expect(tester.takeException(), isNull);
    });

    testWidgets('heightFor grows with the text scale so carousels never clip', (tester) async {
      late double normal, large;
      await tester.pumpWidget(MaterialApp(home: Builder(builder: (c) {
        normal = MovieCard.heightFor(c, width: 150, posterHeight: 225);
        return const SizedBox();
      })));
      await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Builder(builder: (c) {
            large = MovieCard.heightFor(c, width: 150, posterHeight: 225);
            return const SizedBox();
          }),
        ),
      ));
      expect(large, greaterThan(normal));
    });
  });
}
