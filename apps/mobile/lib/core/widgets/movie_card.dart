import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nozie_mobile/app/app_router.dart';
import 'package:nozie_mobile/core/enums/movie_type.dart';
import 'package:nozie_mobile/core/models/movie_item.dart';
import 'package:nozie_mobile/core/theme/app_colors.dart';
import 'package:nozie_mobile/core/theme/app_spacing.dart';
import 'package:nozie_mobile/core/utils/image_constant.dart';
import 'package:nozie_mobile/core/utils/price_utils.dart';
import 'package:nozie_mobile/core/widgets/image_utils.dart';

/// A movie tile in three layouts:
///  - [MovieCardType.horizontal]: poster, then title and rating/price underneath (carousels, grids)
///  - [MovieCardType.vertical]: poster on the left, details on the right (lists)
///  - [MovieCardType.titleInImg]: title laid over the poster (banners, genre tiles)
///
/// [height] is the **poster** height; the text below adds its own height ([heightFor] gives the total,
/// which carousels need to size themselves).
class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.movie,
    this.width = 180,
    this.height = 276,
    this.movieCardType = MovieCardType.horizontal,
    this.onMore,
    this.genres,
    this.enableNavigation = true,
    this.titleFontSize,
    this.overlayOpacity,
  });

  final MovieItem movie;
  final double width;
  final double height;
  final MovieCardType movieCardType;
  final List<String>? genres;
  final VoidCallback? onMore;
  final bool enableNavigation;

  /// Title size for [MovieCardType.titleInImg]; defaults to a size derived from [width].
  final double? titleFontSize;

  /// Extra dimming under an overlaid title.
  final double? overlayOpacity;

  static const double _gap = AppSpacing.sm;
  static const double _titleLines = 2;

  double get _scale => (width / 180).clamp(0.7, 1.4);
  double get _titleSize => 16 * _scale;
  bool get _showMeta => movie.rating != null;

  /// Total height of a horizontal card whose poster is [posterHeight] tall, honouring the user's text scale.
  static double heightFor(BuildContext context, {required double width, required double posterHeight}) {
    final scaler = MediaQuery.textScalerOf(context);
    final scale = (width / 180).clamp(0.7, 1.4);
    final titleBlock = scaler.scale(16 * scale) * 1.3 * _titleLines;
    final metaBlock = scaler.scale(14 * scale) * 1.4;
    // Text layout rounds each line up to whole pixels; the margin absorbs that so a carousel never clips.
    const rounding = 4.0;
    return posterHeight + _gap + titleBlock + AppSpacing.xs + metaBlock + rounding;
  }

  void _open(BuildContext context) {
    if (onMore != null) {
      onMore!();
    } else if (enableNavigation) {
      context.push('${AppRouter.movie}/${movie.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = switch (movieCardType) {
      MovieCardType.vertical => _buildVertical(context),
      MovieCardType.horizontal => _buildHorizontal(context),
      MovieCardType.titleInImg => _buildTitleInImage(context),
    };
    return Semantics(
      button: true,
      label: movie.title,
      child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => _open(context), child: card),
    );
  }

  Widget _buildHorizontal(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _Poster(url: movie.imageUrl, width: width, height: height),
          const SizedBox(height: _gap),
          _Title(movie.title, fontSize: _titleSize),
          if (_showMeta) ...[
            const SizedBox(height: AppSpacing.xs),
            _Meta(movie: movie, scale: _scale),
          ],
        ],
      ),
    );
  }

  Widget _buildVertical(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Poster(url: movie.imageUrl, width: width, height: height),
        const SizedBox(width: AppSpacing.md),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _Title(movie.title, fontSize: _titleSize),
              if (genres != null && genres!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final g in genres!)
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.greyscale800 : AppColors.greyscale200,
                          borderRadius: BorderRadius.circular(AppRadius.sm / 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                          child: Text(g),
                        ),
                      ),
                  ],
                ),
              ],
              if (_showMeta) ...[
                const SizedBox(height: AppSpacing.md),
                _Meta(movie: movie, scale: _scale, stacked: true),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleInImage(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              _Poster(url: movie.imageUrl, width: width, height: height),
              // A bottom scrim keeps white text legible on any image.
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: overlayOpacity ?? 0),
                          Colors.black.withValues(alpha: 0.65),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: AppSpacing.sm + AppSpacing.xs,
                right: AppSpacing.sm,
                bottom: AppSpacing.sm,
                child: Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: titleFontSize ?? 9 * _scale,
                  ),
                ),
              ),
            ],
          ),
          if (_showMeta) ...[
            const SizedBox(height: AppSpacing.sm),
            _Meta(movie: movie, scale: _scale),
          ],
        ],
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({required this.url, required this.width, required this.height});

  final String url;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: NetworkOrAssetImage(imageUrl: url, width: width, height: height, fit: BoxFit.cover),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.text, {required this.fontSize});

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700, fontSize: fontSize, height: 1.3),
    );
  }
}

/// Rating and price on one line (or stacked in list rows). Free movies get an accent label.
class _Meta extends StatelessWidget {
  const _Meta({required this.movie, required this.scale, this.stacked = false});

  final MovieItem movie;
  final double scale;
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 14 * scale,
          height: 1.4,
          color: isDark ? AppColors.greyscale300 : AppColors.greyscale700,
        );
    final price = PriceUtils.formatPrice(movie);
    final free = PriceUtils.isFree(movie);

    final rating = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(ImageConstant.groupIcon, width: 16 * scale, height: 16 * scale),
        const SizedBox(width: AppSpacing.xs + 2),
        Text((movie.rating ?? 0).toStringAsFixed(1), style: base),
      ],
    );
    final priceText = price.isEmpty
        ? const SizedBox.shrink()
        : Text(
            price,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: free ? base?.copyWith(color: AppColors.primary500, fontWeight: FontWeight.w700) : base,
          );

    return stacked
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [rating, const SizedBox(height: AppSpacing.xs), priceText])
        : Row(children: [rating, const SizedBox(width: AppSpacing.md), Flexible(child: priceText)]);
  }
}
