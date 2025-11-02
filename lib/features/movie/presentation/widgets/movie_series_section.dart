import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/app_export.dart';
import '../../../../core/utils/image_constant.dart';

class MovieSeriesSection extends StatelessWidget {
  const MovieSeriesSection({
    super.key,
    required this.seriesTitle,
    required this.seriesItems,
    this.onViewAllPressed,
  });

  final String seriesTitle;
  final List<String> seriesItems;
  final VoidCallback? onViewAllPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = AppColors.getText(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              seriesTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_forward,
                color: AppColors.primary500,
              ),
              onPressed: onViewAllPressed,
            ),
          ],
        ),
        const Gap(12),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: seriesItems.length,
            separatorBuilder: (_, __) => const Gap(12),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  seriesItems[index],
                  width: 120,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

