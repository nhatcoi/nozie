import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_fe/core/enums/movie_type.dart';

import '../../models/movie_item.dart';
import '../../theme/app_colors.dart';
import '../../utils/image_constant.dart';
import '../../../routes/app_router.dart';

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
  });

  final MovieItem movie;
  final double width;
  final double height;

  final MovieCardType movieCardType;

  final List<String>? genres;

  final VoidCallback? onMore;
  
  final bool enableNavigation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scale = width / 180;

    void _handleTap(BuildContext context) {
      if (onMore != null) {
        onMore!();
      } else if (enableNavigation) {
        context.push('${AppRouter.movie}/${movie.id}');
      }
    }

    return GestureDetector(
      onTap: () => _handleTap(context),
      child: SizedBox(
        width: width,
        child: movieCardType == MovieCardType.vertical
            ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPosterImage(),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  _buildTitle(theme, scale),
                  if (movie.price != null && movie.rating != null) ...[
                    const Gap(12),
                    _buildMetadata(theme, isDark, scale, type: movieCardType),
                    const Gap(12),

                    genres != null ? Row(
                      spacing: 12,
                      children: genres!.map((g) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.greyscale800 : AppColors.greyscale200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(g),
                      )).toList(),
                    ) : Container(),
                  ],
                ],
              ),
            ),
          ],
        )
            : Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (movieCardType != MovieCardType.titleInImg) ...[
              _buildPosterImage(),
              const Gap(8),
              _buildTitle(theme, scale),
            ] else ...[
              Stack(
                children: [
                  _buildPosterImage(),
                  Positioned(
                    bottom: 0,
                    left: 5,
                    child: _buildTitle2(scale),
                  ),
                ],
              ),
            ],
            if (movie.price != null && movie.rating != null) ...[
              const Gap(6),
              _buildMetadata(theme, isDark, scale),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPosterImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        movie.imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildTitle(ThemeData theme, double scale) {
    return Text(
      movie.title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 18 * scale,
      ),
    );
  }

  Widget _buildTitle2(double scale) {
    return Text(
      movie.title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 18 * scale,
      ),
    );
  }

  Widget _buildMetadata(ThemeData theme, bool isDark, double scale, { MovieCardType type = MovieCardType.horizontal}) {
    final textStyle = theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: 18 * scale,
      color: isDark ? AppColors.greyscale300 : AppColors.greyscale700,
    );

    return type == MovieCardType.horizontal ? Row(
      children: [
        _buildRating(textStyle, scale),
        const Gap(12),
        _buildPrice(textStyle),
      ],
    ) : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRating(textStyle, scale),
        const Gap(12),
        _buildPrice(textStyle),
      ],
    );
  }

  Widget _buildRating(TextStyle? textStyle, double scale) {
    return Row(
      children: [
        SvgPicture.asset(
          ImageConstant.groupIcon,
          width: 16 * scale,
          height: 16 * scale,
        ),
        const Gap(6),
        Text(movie.rating.toString(), style: textStyle),
      ],
    );
  }

  Widget _buildPrice(TextStyle? textStyle) {
    return Text('\$${movie.price?.toStringAsFixed(2)}', style: textStyle);
  }
}
