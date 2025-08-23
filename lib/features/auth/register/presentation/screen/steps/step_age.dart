import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_typography.dart';
import '../../../../../../core/widgets/tag.dart';

class StepAge extends StatefulWidget {
  final Function(String) onAgeSelected;
  final String? selectedAge;

  const StepAge({
    super.key,
    required this.onAgeSelected,
    this.selectedAge,
  });

  @override
  State<StepAge> createState() => _StepAgeState();
}

class _StepAgeState extends State<StepAge> {
  String? selectedAge;

  // Text content variables
  static const String title = 'Choose your Age';
  static const String subtitle = 'Select age range for better content';

  // Age range options
  static const Map<String, String> ageOptions = {
    '14-17': '14-17',
    '18-24': '18-24',
    '25-29': '25-29',
    '30-34': '30-34',
    '35-39': '35-39',
    '40-44': '40-44',
    '45-49': '45-49',
    '50': '50+',
  };

  @override
  void initState() {
    super.initState();
    selectedAge = widget.selectedAge;
  }

  void _selectAge(String age) {
    setState(() {
      selectedAge = age;
    });
    widget.onAgeSelected(age);
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

          // Age Options Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final tagWidth = (screenWidth - 48) / 2; // 2 columns with 12px gap
              
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: ageOptions.entries.map((entry) => SizedBox(
                  width: tagWidth,
                  child: Tag(
                    text: entry.value,
                    isSelected: selectedAge == entry.key,
                    onTap: () => _selectAge(entry.key),
                    padding: EdgeInsets.symmetric(
                      horizontal: tagWidth * 0.15, // 15% of tag width
                      vertical: 10,
                    ),
                    fontWeight: FontWeight.w800,
                  ),
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
