import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../viewmodel/signup_viewmodel.dart';
import 'steps/step_gender.dart';
import 'steps/step_age.dart';
import 'steps/step_genre.dart';
import 'steps/step_profile.dart';
import 'steps/step_signup.dart';

class SignupFlowScreen extends ConsumerStatefulWidget {
  const SignupFlowScreen({super.key});

  @override
  ConsumerState<SignupFlowScreen> createState() => _SignupFlowScreenState();
}

class _SignupFlowScreenState extends ConsumerState<SignupFlowScreen> {
  int currentStep = 0;
  final int totalSteps = 5;
  String? selectedGender;
  String? selectedAge;
  List<String> selectedGenres = [];
  Map<String, String> profileData = {};
  Map<String, dynamic> signupData = {};

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

  bool _canProceedToNextStep() {
    switch (currentStep) {
      case 0:
        return selectedGender != null;
      case 1:
        return selectedAge != null;
      case 2:
        return true; // Genre step can be skipped
      case 3:
        return profileData.isNotEmpty && 
               profileData['fullName']?.isNotEmpty == true &&
               profileData['phone']?.isNotEmpty == true &&
               profileData['dob']?.isNotEmpty == true &&
               profileData['country']?.isNotEmpty == true;
      case 4:
        return signupData.isNotEmpty && 
               signupData['username']?.isNotEmpty == true &&
               signupData['email']?.isNotEmpty == true &&
               signupData['password']?.isNotEmpty == true &&
               signupData['confirmPassword']?.isNotEmpty == true;
      default:
        return true;
    }
  }

  void _handleSignUp() {
    final signupViewModel = ref.read(signupViewModelProvider.notifier);
    
    signupViewModel.registerUser(
      gender: selectedGender,
      age: selectedAge,
      genres: selectedGenres,
      profileData: profileData,
      accountData: signupData,
    );
  }

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(signupViewModelProvider);
    
    // Handle success state
    if (signupState.isSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful!'),
            backgroundColor: AppColors.green,
          ),
        );
        // Navigate to next screen or reset
        Navigator.pop(context);
      });
    }

    // Handle error state
    if (signupState.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(signupState.error!),
            backgroundColor: AppColors.red,
          ),
        );
        // Clear error after showing
        ref.read(signupViewModelProvider.notifier).clearError();
      });
    }

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
      case 1:
        return StepAge(
          onAgeSelected: (age) {
            setState(() {
              selectedAge = age;
            });
          },
          selectedAge: selectedAge,
        );
      case 2:
        return StepGenre(
          onGenresSelected: (genres) {
            setState(() {
              selectedGenres = genres;
            });
          },
          selectedGenres: selectedGenres,
        );
      case 3:
        return StepProfile(
          onProfileCompleted: (data) {
            setState(() {
              profileData = data;
            });
          },
          initialData: profileData.isNotEmpty ? profileData : null,
        );
      case 4:
        return StepSignup(
          onSignupCompleted: (data) {
            setState(() {
              signupData = data;
            });
          },
          initialData: signupData.isNotEmpty ? signupData : null,
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
    final isStep3 = currentStep == 2; // Genre step
    final signupState = ref.watch(signupViewModelProvider);

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
              onPressed: signupState.isLoading 
                  ? null 
                  : (isLastStep ? _handleSignUp : (_canProceedToNextStep() ? _nextStep : null)),
              backgroundColor: signupState.isLoading
                  ? AppColors.greyscale200
                  : (_canProceedToNextStep() 
                      ? AppColors.primary500 
                      : AppColors.greyscale200),
              textColor: signupState.isLoading
                  ? AppColors.greyscale500
                  : (_canProceedToNextStep() 
                      ? AppColors.white 
                      : AppColors.greyscale500),
            ),
          ),
        ],
      ),
    );
  }
}
