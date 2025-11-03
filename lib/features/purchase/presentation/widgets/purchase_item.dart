import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/app_export.dart';
import '../../../../core/widgets/image_utils.dart';
import '../../../../core/repositories/movie_repository.dart';
import '../../../../routes/app_router.dart';
import '../../models/purchase_item.dart' as purchase_model;
import '../../application/purchase_state_notifier.dart';

enum PurchaseAction {
  removeDownload,
  viewSeries,
  markAsFinished,
  aboutEbook,
}

class PurchaseItemWidget extends ConsumerStatefulWidget {
  const PurchaseItemWidget({
    super.key,
    required this.item,
  });

  final purchase_model.PurchaseItem item;

  @override
  ConsumerState<PurchaseItemWidget> createState() => _PurchaseItemWidgetState();
}

class _PurchaseItemWidgetState extends ConsumerState<PurchaseItemWidget> {
  final GlobalKey _buttonKey = GlobalKey();

  void _showActionMenu(BuildContext context, WidgetRef ref) {
    final RenderBox? button =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (button == null) return;

    final buttonPosition = button.localToGlobal(Offset.zero);
    final buttonSize = button.size;
    final screenSize = MediaQuery.of(context).size;
    final textColor = AppColors.getText(context);
    final secondaryText = AppColors.getTextSecondary(context);
    final modalBackground = AppColors.getModalBackground(context);
    final theme = Theme.of(context);

    const menuWidth = 200.0;
    final buttonRight = buttonPosition.dx + buttonSize.width;
    final menuLeft = (buttonRight - menuWidth).clamp(8.0, screenSize.width - menuWidth - 8);
    final menuTop = buttonPosition.dy + buttonSize.height + 8;
    final menuRight = screenSize.width - menuLeft - menuWidth;

    showMenu<PurchaseAction>(
      context: context,
      useRootNavigator: true,
      color: modalBackground,
      position: RelativeRect.fromLTRB(
        menuLeft,
        menuTop,
        menuRight,
        menuTop,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      items: [
        PopupMenuItem<PurchaseAction>(
          value: PurchaseAction.removeDownload,
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                SvgPicture.asset(
                  ImageConstant.paperNegativeIcon,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    textColor,
                    BlendMode.srcIn,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Text(
                    'Watch now',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem<PurchaseAction>(
          value: PurchaseAction.viewSeries,
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                SvgPicture.asset(
                  ImageConstant.listCategoryIcon,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    textColor,
                    BlendMode.srcIn,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Text(
                    'View Series',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem<PurchaseAction>(
          value: PurchaseAction.markAsFinished,
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                SvgPicture.asset(
                  ImageConstant.imgCheckedIcon,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    textColor,
                    BlendMode.srcIn,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Text(
                    'Mark as Finished',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem<PurchaseAction>(
          value: PurchaseAction.aboutEbook,
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                SvgPicture.asset(
                  ImageConstant.infoSquareIcon,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    textColor,
                    BlendMode.srcIn,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Text(
                    'About Movie',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ).then((value) {
      if (value != null && context.mounted) {
        _handleAction(context, ref, value);
      }
    });
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    PurchaseAction action,
  ) async {
    switch (action) {
      case PurchaseAction.removeDownload:
        // Navigate to video player
        try {
          final movieRepo = ref.read(movieRepoProvider);
          final movie = await movieRepo.getMovieDetail(widget.item.id);
          if (movie != null && context.mounted) {
            final videoUrl = _getVideoUrl(movie);
            context.push(
              '${AppRouter.videoPlayer}/${movie.id}',
              extra: {
                'movie': movie,
                'videoUrl': videoUrl,
              },
            );
          } else if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Movie not found'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${e.toString()}'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
        break;
      case PurchaseAction.viewSeries:
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('View series - coming soon'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        break;
      case PurchaseAction.markAsFinished:
        ref.read(purchaseStateProvider.notifier).markAsFinished(widget.item.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Marked as finished'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        break;
      case PurchaseAction.aboutEbook:
        try {
          final movieRepo = ref.read(movieRepoProvider);
          final movie = await movieRepo.getMovieDetail(widget.item.id);
          if (movie != null && context.mounted) {
            context.push(
              '${AppRouter.movieInfo}/${movie.id}',
              extra: {'movie': movie},
            );
          } else if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Movie not found'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${e.toString()}'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = AppColors.getText(context);
    final secondaryText = AppColors.getTextSecondary(context);

    return InkWell(
      onTap: () {
        context.push('${AppRouter.movie}/${widget.item.id}');
      },
      child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: NetworkOrAssetImage(
            imageUrl: widget.item.imageUrl,
            width: 80,
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: textColor,
                ),
              ),
              if (widget.item.rating != null) ...[
                const Gap(8),
                Row(
                  children: [
                    SvgPicture.asset(
                      ImageConstant.groupIcon,
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        secondaryText,
                        BlendMode.srcIn,
                      ),
                    ),
                    const Gap(6),
                    Text(
                      widget.item.rating?.toStringAsFixed(1) ?? '0.0',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
              const Gap(8),
              Text(
                'Purchased',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: secondaryText,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: widget.item.isFinished
                  ? SvgPicture.asset(
                      ImageConstant.imgCheckedIcon,
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        AppColors.primary500,
                        BlendMode.srcIn,
                      ),
                    )
                  : Icon(
                      Icons.download_outlined,
                      color: secondaryText,
                      size: 24,
                    ),
              onPressed: () {},
            ),
            IconButton(
              key: _buttonKey,
              icon: Icon(
                Icons.more_vert,
                color: secondaryText,
                size: 24,
              ),
              onPressed: () => _showActionMenu(context, ref),
            ),
          ],
        ),
      ],
      ),
    );
  }

  String? _getVideoUrl(dynamic movie) {
    if (movie.trailerUrl != null && movie.trailerUrl!.isNotEmpty) {
      final t = movie.trailerUrl!;
      final isDirectStream = t.contains('.m3u8') || t.contains('.mp4');
      final isYouTube = t.contains('youtube.com') || t.contains('youtu.be');
      if (isDirectStream && !isYouTube) {
        return t;
      }
    }
    
    if (movie.episodes != null && movie.episodes!.isNotEmpty) {
      // Try to get first episode's video URL
      final firstEpisode = movie.episodes!.first;
      
      // Check if it's a server structure (has server_data)
      if (firstEpisode['server_data'] != null && firstEpisode['server_data'] is List) {
        final serverData = firstEpisode['server_data'] as List;
        if (serverData.isNotEmpty) {
          final firstVideo = serverData.first;
          if (firstVideo['link_m3u8'] != null &&
              (firstVideo['link_m3u8'].toString().contains('.m3u8') ||
               firstVideo['link_m3u8'].toString().contains('.mp4'))) {
            return firstVideo['link_m3u8'].toString();
          }
          if (firstVideo['link_embed'] != null) {
            return firstVideo['link_embed'].toString();
          }
        }
      }
      
      // Direct episode structure
      if (firstEpisode['url'] != null) {
        return firstEpisode['url'].toString();
      }
      if (firstEpisode['videoUrl'] != null) {
        return firstEpisode['videoUrl'].toString();
      }
      if (firstEpisode['link_m3u8'] != null) {
        return firstEpisode['link_m3u8'].toString();
      }
      if (firstEpisode['link_embed'] != null) {
        return firstEpisode['link_embed'].toString();
      }
    }
    
    return null;
  }
}

