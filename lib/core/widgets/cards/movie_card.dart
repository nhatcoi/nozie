import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../models/movie_item.dart';
import '../../theme/app_colors.dart';
import '../../utils/image_constant.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.movie,
    this.width = 180,
    this.height = 276,
  });

  final MovieItem movie;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scale = width / 180;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPosterImage(),
          const Gap(8),
          _buildTitle(theme, scale),
          const Gap(6),
          _buildMetadata(theme, isDark, scale),
        ],
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

  Widget _buildMetadata(ThemeData theme, bool isDark, double scale) {
    final textStyle = theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: 18 * scale,
      color: isDark ? AppColors.greyscale300 : AppColors.greyscale700,
    );

    return Row(
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
        Text(
          movie.rating.toString(),
          style: textStyle,
        ),
      ],
    );
  }

  Widget _buildPrice(TextStyle? textStyle) {
    return Text(
      '\$${movie.price.toStringAsFixed(2)}',
      style: textStyle,
    );
  }
}