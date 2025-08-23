import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_typography.dart';
import '../../../../../../core/widgets/tag.dart';

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

  // Text content variables
  static const String title = 'Choose the Movie Genre You Like';
  static const String subtitle = 'Select your preferred movie genre for better recommendation or you can skip it';

  // Movie genre options
  static const Map<String, String> genreOptions = {
    'action': 'Action',
    'adventure': 'Adventure',
    'animation': 'Animation',
    'comedy': 'Comedy',
    'crime': 'Crime',
    'documentary': 'Documentary',
    'drama': 'Drama',
    'family': 'Family',
    'fantasy': 'Fantasy',
    'horror': 'Horror',
    'mystery': 'Mystery',
    'romance': 'Romance',
    'sci_fi': 'Sci-Fi',
    'thriller': 'Thriller',
    'war': 'War',
    'western': 'Western',
  };

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
            title,
            style: AppTypography.h3.copyWith(
              color: AppColors.greyscale900,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          // Subtitle
          Text(
            subtitle,
            style: AppTypography.bodyLRegular.copyWith(
              color: AppColors.greyscale900,
            ),
          ),
          const SizedBox(height: 32),

          // Genre Options Grid
          Wrap(
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
          ),
        ],
      ),
    );
  }
}
