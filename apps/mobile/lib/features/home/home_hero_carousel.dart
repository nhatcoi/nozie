import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nozie_mobile/app/app_router.dart';
import 'package:nozie_mobile/core/models/movie_item.dart';
import 'package:nozie_mobile/core/theme/app_colors.dart';
import 'package:nozie_mobile/core/theme/app_spacing.dart';
import 'package:nozie_mobile/core/widgets/image_utils.dart';
import 'package:nozie_mobile/core/widgets/skeleton.dart';

/// Full-width featured banner: 16:9 cards, page dots, auto-advance that pauses while the user is touching it.
class HomeHeroCarousel extends StatefulWidget {
  const HomeHeroCarousel({super.key, required this.items});

  final List<MovieItem> items;

  @override
  State<HomeHeroCarousel> createState() => _HomeHeroCarouselState();
}

class _HomeHeroCarouselState extends State<HomeHeroCarousel> {
  static const _autoAdvance = Duration(seconds: 5);
  static const _maxItems = 6;

  final _controller = PageController(viewportFraction: 0.92);
  Timer? _timer;
  int _page = 0;

  List<MovieItem> get _items => widget.items.take(_maxItems).toList();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    if (_items.length < 2) return;
    _timer = Timer.periodic(_autoAdvance, (_) {
      if (!mounted || !_controller.hasClients) return;
      final next = (_page + 1) % _items.length;
      unawaited(_controller.animateToPage(next, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n is ScrollStartNotification && n.dragDetails != null) _timer?.cancel();
              if (n is ScrollEndNotification) _startTimer();
              return false;
            },
            child: PageView.builder(
              controller: _controller,
              itemCount: items.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: _HeroCard(movie: items[i]),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _Dots(count: items.length, active: _page),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.movie});

  final MovieItem movie;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: movie.title,
      child: GestureDetector(
        onTap: () => context.push('${AppRouter.movie}/${movie.id}'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Stack(
            fit: StackFit.expand,
            children: [
              NetworkOrAssetImage(imageUrl: movie.imageUrl, fit: BoxFit.cover),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xCC000000)],
                  ),
                ),
              ),
              Positioned(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                bottom: AppSpacing.lg,
                child: Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    if (count < 2) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == active ? 20 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == active ? AppColors.primary500 : AppColors.getLine(context),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
    );
  }
}

/// Whole-page placeholder for the first load.
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(aspectRatio: 16 / 9, child: Skeleton(height: double.infinity, radius: AppRadius.xl)),
          SizedBox(height: AppSpacing.xl),
          Skeleton(width: 180, height: 22),
          SizedBox(height: AppSpacing.md),
          MovieRowSkeleton(),
          SizedBox(height: AppSpacing.xl),
          Skeleton(width: 140, height: 22),
          SizedBox(height: AppSpacing.md),
          MovieRowSkeleton(),
        ],
      ),
    );
  }
}
