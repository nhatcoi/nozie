import 'package:flutter/material.dart';
import '../../../../../../core/app_export.dart';

class StepGenre extends StatefulWidget {
  final Function(List<String>) onGenresSelected;
  final List<String>? selectedGenres;

  const StepGenre({
    super.key,
    required this.onGenresSelected,
    this.selectedGenres,
  });

  @override
  State<StepGenre> createState() => _StepGenreState();
}

class _StepGenreState extends State<StepGenre> {
  List<String> selectedGenres = [];

  // Movie genre options with localization
  Map<String, String> getGenreOptions(BuildContext context) {
    return {
      'action': context.l10n.action,
      'adventure': context.l10n.adventure,
      'animation': context.l10n.animation,
      'comedy': context.l10n.comedy,
      'crime': context.l10n.crime,
      'documentary': context.l10n.documentary,
      'drama': context.l10n.drama,
      'family': context.l10n.family,
      'fantasy': context.l10n.fantasy,
      'horror': context.l10n.horror,
      'mystery': context.l10n.mystery,
      'romance': context.l10n.romance,
      'sci_fi': context.l10n.sciFi,
      'thriller': context.l10n.thriller,
      'war': context.l10n.war,
      'western': context.l10n.western,
    };
  }

  @override
  void initState() {
    super.initState();
    selectedGenres = widget.selectedGenres ?? [];
  }

  void _toggleGenre(String genre) {
    setState(() {
      if (selectedGenres.contains(genre)) {
        selectedGenres.remove(genre);
      } else {
        selectedGenres.add(genre);
      }
    });
    widget.onGenresSelected(selectedGenres);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          
          // Title
          Text(
            context.l10n.chooseMovieGenre,
            style: AppTypography.h3.copyWith(
              color: AppColors.getText(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          // Subtitle
          Text(
            context.l10n.selectPreferredGenre,
            style: AppTypography.bodyLRegular.copyWith(
              color: AppColors.getTextSecondary(context),
            ),
          ),
          const SizedBox(height: 32),

          // Grid
          Builder(
            builder: (context) {
              final genreOptions = getGenreOptions(context);
              return Wrap(
                spacing: 12,
                runSpacing: 16,
                children: genreOptions.entries.map((entry) => Tag(
                  text: entry.value,
                  isSelected: selectedGenres.contains(entry.key),
                  onTap: () => _toggleGenre(entry.key),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
