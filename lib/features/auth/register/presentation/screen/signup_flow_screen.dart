import 'package:flutter/material.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/primary_button.dart';
import 'steps/step_gender.dart';

class SignupFlowScreen extends StatefulWidget {
  const SignupFlowScreen({super.key});

  @override
  State<SignupFlowScreen> createState() => _SignupFlowScreenState();
}

class _SignupFlowScreenState extends State<SignupFlowScreen> {
  int currentStep = 0;
  final int totalSteps = 5;
  String? selectedGender;

  void _nextStep() {
    if (currentStep < totalSteps - 1) {
      setState(() {
        currentStep++;
      });
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Process Bar Section
            _buildProcessBar(),

            // Content Area - content - of 5 steps
            Expanded(
              child: _buildStepContent(),
            ),




            // Button Bar Section
            _buildButtonBar(),
          ],
        ),
      ),
    );
  }

  
  Widget _buildProcessBar() {
    final progress = (currentStep + 1) / totalSteps;

    return Container(
      width: double.infinity,
      height: 48,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Stack(
        children: [
          // Progress bar container
          Center(
            child: Container(
              width: 200, // Fixed shorter width
              height: 12,
              decoration: ShapeDecoration(
                color: AppColors.greyscale200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Stack(
                children: [
                  // Background track
                  Container(
                    width: 200,
                    height: 12,
                    decoration: ShapeDecoration(
                      color: AppColors.greyscale200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  // Progress fill
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    width: 200 * progress,
                    height: 12,
                    decoration: ShapeDecoration(
                      color: AppColors.primary500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Back arrow (positioned absolutely)
          Positioned(
            left: 0,
            top: -5, // Raised up a little
            child: GestureDetector(
              onTap: () {
                if (currentStep == 0) {
                  // back to welcome
                  Navigator.pop(context);
                } else {
                  _previousStep();
                }

              },
              child: SizedBox(
                width: 32,
                height: 32,
                child: const Icon(
                  Icons.arrow_back,
                  size: 18,
                  color: AppColors.greyscale900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return StepGender(
          onGenderSelected: (gender) {
            setState(() {
              selectedGender = gender;
            });
          },
          selectedGender: selectedGender,
        );
      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Step ${currentStep + 1} of $totalSteps',
                style: AppTypography.h4.copyWith(
                  color: AppColors.greyscale900,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Content for step ${currentStep + 1}',
                style: AppTypography.bodyLRegular.copyWith(
                  color: AppColors.greyscale600,
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildButtonBar() {
    final isLastStep = currentStep == totalSteps - 1;
    final isStep3 = currentStep == 2;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.white,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Skip button (only for step 3)
          if (isStep3)
            Expanded(
              child: PrimaryButton(
                text: 'Skip',
                onPressed: () {
                  setState(() {
                    currentStep = totalSteps - 1;
                  });
                },
                backgroundColor: AppColors.primary100,
                textColor: AppColors.primary500,
              ),
            ),

          if (isStep3) const SizedBox(width: 16),

          // Continue/Sign Up button
          Expanded(
            child: PrimaryButton(
              text: isLastStep ? 'Sign Up' : 'Continue',
              onPressed: (currentStep == 0 && selectedGender == null) ? null : _nextStep,
              backgroundColor: (currentStep == 0 && selectedGender == null) 
                  ? AppColors.greyscale200 
                  : AppColors.primary500,
              textColor: (currentStep == 0 && selectedGender == null) 
                  ? AppColors.greyscale500 
                  : AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
