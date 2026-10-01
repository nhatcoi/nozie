import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:nozie_mobile/core/app_export.dart';
import 'package:nozie_mobile/core/models/movie.dart';
import 'package:nozie_mobile/features/movie/movie_info_panel.dart';

class MovieInfoScreen extends ConsumerWidget {
  const MovieInfoScreen({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.getText(context)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          movie.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.getText(context),
                fontWeight: FontWeight.w600,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MovieInfoPanel(movie: movie),
            const Gap(48),
          ],
        ),
      ),
    );
  }
}
