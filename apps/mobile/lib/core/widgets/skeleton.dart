import 'package:flutter/material.dart';
import 'package:nozie_mobile/core/theme/app_colors.dart';
import 'package:nozie_mobile/core/theme/app_spacing.dart';

/// A pulsing placeholder block shown while content loads (better than a lone spinner because
/// the page keeps its shape and nothing jumps when data arrives).
class Skeleton extends StatefulWidget {
  const Skeleton({super.key, this.width, this.height = 16, this.radius = AppRadius.sm});

  final double? width;
  final double height;
  final double radius;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? AppColors.dark2 : AppColors.greyscale200;
    final highlight = isDark ? AppColors.dark3 : AppColors.greyscale100;
    // Skeletons are decoration: keep them out of the accessibility tree.
    return ExcludeSemantics(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Color.lerp(base, highlight, _controller.value),
            borderRadius: BorderRadius.circular(widget.radius),
          ),
        ),
      ),
    );
  }
}

/// Placeholder shaped like a poster card with a title and a meta line.
class MovieCardSkeleton extends StatelessWidget {
  const MovieCardSkeleton({super.key, required this.width, required this.posterHeight});

  final double width;
  final double posterHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton(width: width, height: posterHeight, radius: AppRadius.lg),
          const SizedBox(height: AppSpacing.sm),
          Skeleton(width: width * 0.9, height: 14),
          const SizedBox(height: AppSpacing.xs),
          Skeleton(width: width * 0.55, height: 14),
        ],
      ),
    );
  }
}

/// Horizontal strip of [MovieCardSkeleton]s standing in for a carousel.
class MovieRowSkeleton extends StatelessWidget {
  const MovieRowSkeleton({super.key, this.cardWidth = 150, this.count = 3});

  final double cardWidth;
  final int count;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        children: [
          for (var i = 0; i < count; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.lg),
            MovieCardSkeleton(width: cardWidth, posterHeight: cardWidth * 1.5),
          ],
        ],
      ),
    );
  }
}
