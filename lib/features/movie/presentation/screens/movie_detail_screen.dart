import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/app_export.dart';
import '../../../../core/models/movie_item.dart';
import '../../application/notifiers/movie_detail_notifier.dart';
import '../widgets/movie_hero_section.dart';
import '../widgets/movie_rating_section.dart';
import '../widgets/movie_series_section.dart';
import '../widgets/movie_similar_section.dart';

class MovieDetailScreen extends ConsumerStatefulWidget {
  const MovieDetailScreen({
    super.key,
    required this.movieId,
  });

  final String movieId;

  @override
  ConsumerState<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends ConsumerState<MovieDetailScreen> {
  bool _isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = AppColors.getText(context);
    final movieDetailAsync = ref.watch(movieDetailProvider(widget.movieId));

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context, textColor),
      body: movieDetailAsync.when(
        data: (movieData) {
          if (movieData == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.movie, size: 64, color: Colors.grey),
                  const Gap(16),
                  Text(
                    'Movie not found',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: textColor,
                    ),
                  ),
                ],
              ),
            );
          }

          return _buildMovieContent(context, theme, movieData);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const Gap(16),
              Text(
                'Error: ${error.toString()}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovieContent(
    BuildContext context,
    ThemeData theme,
    Map<String, dynamic> movieData,
  ) {
    final movie = MovieItem(
      id: movieData['id'] as String,
      title: movieData['title'] as String,
      imageUrl: movieData['imageUrl'] as String,
      rating: movieData['rating'] as double?,
      price: movieData['price'] as double?,
    );

    final director = movieData['director'] as String;
    final genres = List<String>.from(movieData['genres'] as List);
    final duration = movieData['duration'] as String;
    final size = movieData['size'] as String;
    final views = movieData['views'] as String;
    final description = movieData['description'] as String;
    final rating = movieData['rating'] as double;
    final ratingCount = movieData['ratingCount'] as int;
    final franchiseId = movieData['franchiseId'] as String?;
    final franchiseName = movieData['franchiseName'] as String?;

    final metadata = '⭐ $rating / 5 • $duration • $size • $views';

    return CustomScrollView(
      slivers: [
        // Hero Image with Gradient Overlay
        SliverToBoxAdapter(
          child: Stack(
            children: [
              _buildHeroImage(context, movie.imageUrl),
              // Gradient overlay for better text visibility
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Content
        SliverPadding(
          padding: ResponsivePadding.content(context),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              MovieHeroSection(
                movie: movie,
                author: director,
                genres: genres,
                metadata: metadata,
                description: description,
                onBuyPressed: () {
                  // TODO: Implement purchase
                },
                onViewMorePressed: () {
                  // TODO: Navigate to full description
                },
              ),
              Gap(32),
              MovieRatingSection(
                rating: rating,
                reviewCount: ratingCount,
                onViewAllPressed: () {
                  // TODO: Navigate to full reviews page
                },
              ),
              if (franchiseId != null) ...[
                Gap(32),
                _buildSeriesSection(context, franchiseId, franchiseName ?? 'Series'),
              ],
              Gap(32),
              _buildSimilarSection(context, widget.movieId),
              Gap(24),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSeriesSection(BuildContext context, String franchiseId, String seriesTitle) {
    final seriesAsync = ref.watch(seriesMoviesProvider(franchiseId));

    return seriesAsync.when(
      data: (seriesMovies) {
        if (seriesMovies.isEmpty) return const SizedBox.shrink();
        
        final imageUrls = seriesMovies
            .map((movie) => movie.imageUrl)
            .toList();

        return MovieSeriesSection(
          seriesTitle: seriesTitle,
          seriesItems: imageUrls,
          onViewAllPressed: () {
            // TODO: Navigate to series page
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildSimilarSection(BuildContext context, String movieId) {
    final similarAsync = ref.watch(similarMoviesProvider(movieId));

    return similarAsync.when(
      data: (similarMovies) {
        if (similarMovies.isEmpty) return const SizedBox.shrink();
        
        return MovieSimilarSection(
          similarMovies: similarMovies,
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, Color textColor) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              ImageConstant.sendIcon,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
          onPressed: () {
            // TODO: Implement share
          },
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
              size: 20,
            ),
          ),
          onPressed: () {
            setState(() {
              _isBookmarked = !_isBookmarked;
            });
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildHeroImage(BuildContext context, String imageUrl) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Image.asset(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
