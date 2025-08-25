import 'package:flutter/material.dart';
import '../../../../../../core/app_export.dart';

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

  Map<String, String> getAgeOptions(BuildContext context) {
    return {
      '14-17': context.l10n.age14to17,
      '18-24': context.l10n.age18to24,
      '25-29': context.l10n.age25to29,
      '30-34': context.l10n.age30to34,
      '35-39': context.l10n.age35to39,
      '40-44': context.l10n.age40to44,
      '45-49': context.l10n.age45to49,
      '50': context.l10n.age50plus,
    };
  }

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
          
          Text(context.l10n.chooseYourAge, style: AppTypography.h3.copyWith(
              color: AppColors.getText(context), fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),
          
          Text(context.l10n.selectAgeRange,
            style: AppTypography.bodyLRegular.copyWith(color: AppColors.getTextSecondary(context)),
          ),

          const SizedBox(height: 32),
          
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final tagWidth = (screenWidth - 48) / 2;
              
              final ageOptions = getAgeOptions(context);
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: ageOptions.entries.map((entry) => SizedBox(
                  width: tagWidth,
                  child: Tag(
                    text: entry.value,
                    isSelected: selectedAge == entry.key,
                    onTap: () => _selectAge(entry.key),
                    padding: EdgeInsets.symmetric(horizontal: tagWidth * 0.15, vertical: 10)
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
