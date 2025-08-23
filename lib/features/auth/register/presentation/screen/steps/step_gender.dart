import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_typography.dart';
import '../../../../../../core/widgets/radio_box.dart';

class StepGender extends StatefulWidget {
  final Function(String) onGenderSelected;
  final String? selectedGender;

  const StepGender({
    super.key,
    required this.onGenderSelected,
    this.selectedGender,
  });

  @override
  State<StepGender> createState() => _StepGenderState();
}

class _StepGenderState extends State<StepGender> {
  String? selectedGender;

  // TODO: apply i18n
  // Text content variables
  static const String title = 'What is your gender?';
  static const String subtitle = 'Select gender for better content';
  
  // Gender options map
  static const Map<String, String> genderOptions = {
    'male': 'I am male',
    'female': 'I am female',
    'other': 'Rather not to say',
  };

  @override
  void initState() {
    super.initState();
    selectedGender = widget.selectedGender;
  }

  void _selectGender(String gender) {
    setState(() {
      selectedGender = gender;
    });
    widget.onGenderSelected(gender);
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
          const SizedBox(height: 24),

          // Gender Options
          ...genderOptions.entries.map((entry) => Column(
            children: [
              RadioBox(
                title: entry.value,
                value: entry.key,
                isSelected: selectedGender == entry.key,
                onTap: () => _selectGender(entry.key),
              ),
              if (entry.key != genderOptions.keys.last) ...[
                const SizedBox(height: 16),
                Container(
                  height: 1,
                  color: AppColors.greyscale200,
                ),
                const SizedBox(height: 16),
              ],
            ],
          )),
          const SizedBox(height: 16),

        ],
      ),
    );
  }


}
