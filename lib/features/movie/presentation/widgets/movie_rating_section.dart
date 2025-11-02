import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../../core/app_export.dart';

class MovieRatingSection extends ConsumerStatefulWidget {
  const MovieRatingSection({
    super.key,
    required this.rating,
    required this.reviewCount,
    this.onViewAllPressed,
  });

  final double rating;
  final int reviewCount;
  final VoidCallback? onViewAllPressed;

  @override
  ConsumerState<MovieRatingSection> createState() => _MovieRatingSectionState();
}

class _MovieRatingSectionState extends ConsumerState<MovieRatingSection> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = AppColors.getText(context);
    final secondaryText = AppColors.getTextSecondary(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ratings & Reviews',
              style: theme.textTheme.titleLarge?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_forward,
                color: AppColors.primary500,
                size: 24,
              ),
              onPressed: widget.onViewAllPressed,
            ),
          ],
        ),
        const Gap(24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.rating}',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 48,
                    ),
                  ),
                  const Gap(8),
                  _buildStarRating(widget.rating),
                  const Gap(12),
                  Text(
                    '(${widget.reviewCount} reviews)',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(24),
            Expanded(
              child: _buildRatingDistribution(context, theme, textColor, secondaryText),
            ),
          ],
        ),
        const Gap(32),
        _buildRateSection(context, theme, textColor, secondaryText),
      ],
    );
  }

  Widget _buildStarRating(double rating) {
    // Clamp rating to 0-5 range for display (5-star system)
    final normalizedRating = rating.clamp(0.0, 5.0);
    final fullStars = normalizedRating.floor().clamp(0, 5);
    final remainder = normalizedRating - fullStars;
    final hasPartialStar = remainder > 0 && fullStars < 5;
    final emptyStars = (5 - fullStars - (hasPartialStar ? 1 : 0)).clamp(0, 5);

    return Row(
      children: [
        ...List.generate(fullStars, (_) => Icon(
              Icons.star,
              color: AppColors.primary500,
              size: 24,
            )),
        if (hasPartialStar)
          Stack(
            children: [
              Icon(
                Icons.star_border,
                color: AppColors.primary500,
                size: 24,
              ),
              ClipRect(
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: remainder.clamp(0.0, 1.0),
                  child: Icon(
                    Icons.star,
                    color: AppColors.primary500,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ...List.generate(emptyStars, (_) => Icon(
              Icons.star_border,
              color: AppColors.primary500.withOpacity(0.3),
              size: 24,
            )),
      ],
    );
  }

  Widget _buildRatingDistribution(
    BuildContext context,
    ThemeData theme,
    Color textColor,
    Color secondaryText,
  ) {
    final percentages = [0.65, 0.20, 0.10, 0.03, 0.02];

    return Column(
      children: List.generate(5, (index) {
        final stars = 5 - index;
        final percentage = percentages[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Text(
                  '$stars',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Gap(8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: AppColors.getSurface(context),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary500,
                    ),
                    minHeight: 8,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRateSection(
    BuildContext context,
    ThemeData theme,
    Color textColor,
    Color secondaryText,
  ) {
    int selectedStars = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Rate this Film',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Gap(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starNumber = index + 1;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedStars = starNumber;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      starNumber <= selectedStars
                          ? Icons.star
                          : Icons.star_border,
                      color: starNumber <= selectedStars
                          ? AppColors.primary500
                          : secondaryText.withOpacity(0.5),
                      size: 32,
                    ),
                  ),
                );
              }),
            ),
            const Gap(24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: selectedStars > 0
                    ? () {
                        _showReviewDialog(context, theme, textColor, secondaryText, selectedStars);
                      }
                    : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary500,
                  side: BorderSide(color: AppColors.primary500, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Write a Review',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.primary500,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showReviewDialog(
    BuildContext context,
    ThemeData theme,
    Color textColor,
    Color secondaryText,
    int initialStars,
  ) {
    int selectedStars = initialStars;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.getModalBackground(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Write a Review',
              style: theme.textTheme.titleLarge?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Your rating: $selectedStars ${selectedStars == 1 ? 'star' : 'stars'}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starNumber = index + 1;
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedStars = starNumber;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          starNumber <= selectedStars
                              ? Icons.star
                              : Icons.star_border,
                          color: starNumber <= selectedStars
                              ? AppColors.primary500
                              : secondaryText,
                          size: 40,
                        ),
                      ),
                    );
                  }),
                ),
                const Gap(24),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: secondaryText),
                ),
              ),
              PrimaryButton(
                text: 'Submit',
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Review submitted: $selectedStars stars'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

