import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/app_export.dart';
import '../../../../core/models/movie_item.dart';

class MovieHeroSection extends StatelessWidget {
  const MovieHeroSection({
    super.key,
    required this.movie,
    required this.author,
    required this.genres,
    required this.metadata,
    required this.description,
    required this.onBuyPressed,
    required this.onViewMorePressed,
  });

  final MovieItem movie;
  final String author;
  final List<String> genres;
  final String metadata;
  final String description;
  final VoidCallback? onBuyPressed;
  final VoidCallback? onViewMorePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = AppColors.getText(context);
    final secondaryText = AppColors.getTextSecondary(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeroInfo(context, theme, textColor, secondaryText),
        const Gap(24),
        _buildBuyButton(context, theme),
        const Gap(32),
        _buildAboutSection(context, theme, textColor, secondaryText),
      ],
    );
  }

  Widget _buildHeroInfo(
    BuildContext context,
    ThemeData theme,
    Color textColor,
    Color secondaryText,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            movie.imageUrl,
            width: 120,
            height: 180,
            fit: BoxFit.cover,
          ),
        ),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const Gap(8),
              Text(
                '$author',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: secondaryText,
                ),
              ),
              const Gap(16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: genres.map((genre) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.getSurface(context),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      genre,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const Gap(16),
              Text(
                metadata,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: secondaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBuyButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButton(
        text: 'Buy USD \$${movie.price?.toStringAsFixed(2)}',
        onPressed: onBuyPressed,
      ),
    );
  }

  Widget _buildAboutSection(
    BuildContext context,
    ThemeData theme,
    Color textColor,
    Color secondaryText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'About This Film',
              style: theme.textTheme.titleLarge?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            GestureDetector(
              onTap: onViewMorePressed,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View More',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(4),
                  Icon(
                    Icons.arrow_forward,
                    color: AppColors.primary500,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap(12),
        Text(
          description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: secondaryText,
            height: 1.5,
          ),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

