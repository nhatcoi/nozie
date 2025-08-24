import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/app_export.dart';
import '../viewmodel/signup_viewmodel.dart';
import '../models/signup_step.dart';
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
  SignupStep currentStep = SignupStep.gender;
  String? selectedGender;
  String? selectedAge;
  List<String> selectedGenres = [];
  Map<String, String> profileData = {};
  Map<String, dynamic> signupData = {};

  void _nextStep() {
    final nextStep = currentStep.next;
    if (nextStep != null) {
      setState(() {
        currentStep = nextStep;
      });
    }
  }

  void _previousStep() {
    final previousStep = currentStep.previous;
    if (previousStep != null) {
      setState(() {
        currentStep = previousStep;
      });
    }
  }

  bool _canProceedToNextStep() {
    switch (currentStep) {
      case SignupStep.gender:
        return selectedGender != null;
      case SignupStep.age:
        return selectedAge != null;
      case SignupStep.genre:
        return true; // có thể skip
      case SignupStep.profile:
        return profileData.isNotEmpty && 
               profileData['fullName']?.isNotEmpty == true &&
               profileData['phone']?.isNotEmpty == true &&
               profileData['dob']?.isNotEmpty == true &&
               profileData['country']?.isNotEmpty == true;
      case SignupStep.signup:
        return signupData.isNotEmpty && 
               signupData['username']?.isNotEmpty == true &&
               signupData['email']?.isNotEmpty == true &&
               signupData['password']?.isNotEmpty == true &&
               signupData['confirmPassword']?.isNotEmpty == true;
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
    
    // Success
    if (signupState.isSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.registrationSuccessful),
            backgroundColor: AppColors.green,
          ),
        );
        //
        Navigator.pop(context);
      });
    }

    // Error
    if (signupState.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(signupState.error!),
            backgroundColor: AppColors.red,
          ),
        );
        // Clear
        ref.read(signupViewModelProvider.notifier).clearError();
      });
    }

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildProcessBar(),

            Expanded(
              child: _buildStepContent(),
            ),

            _buildButtonBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessBar() {
    final progress = currentStep.stepNumber / SignupStepExtension.totalSteps;

    return Container(
      width: double.infinity,
      height: 48,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Stack(
        children: [
          // Progress bar container
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barWidth = (constraints.maxWidth * 0.5).clamp(160.0, 320.0); // %50 width
                return SizedBox(
                  width: barWidth,
                  height: 12,
                  child: Stack(
                    children: [
                      Container(
                        decoration: ShapeDecoration(
                          color: AppColors.getSurface(context),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        width: barWidth * progress,
                        decoration: ShapeDecoration(
                          color: AppColors.primary500,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Back arrow
          Positioned(
            left: 0,
            top: -5,
                          child: GestureDetector(
                onTap: () {
                  if (currentStep.isFirst) {
                    Navigator.pop(context);
                  } else {
                    _previousStep();
                  }
                },
              child: SizedBox(
                width: 32,
                height: 32,
                child: Icon(
                  Icons.arrow_back,
                  size: 18,
                  color: AppColors.getText(context),
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
      case SignupStep.gender:
        return StepGender(
          onGenderSelected: (gender) {
            setState(() {
              selectedGender = gender;
            });
          },
          selectedGender: selectedGender,
        );
      case SignupStep.age:
        return StepAge(
          onAgeSelected: (age) {
            setState(() {
              selectedAge = age;
            });
          },
          selectedAge: selectedAge,
        );
      case SignupStep.genre:
        return StepGenre(
          onGenresSelected: (genres) {
            setState(() {
              selectedGenres = genres;
            });
          },
          selectedGenres: selectedGenres,
        );
      case SignupStep.profile:
        return StepProfile(
          onProfileCompleted: (data) {
            setState(() {
              profileData = data;
            });
          },
          initialData: profileData.isNotEmpty ? profileData : null,
        );
      case SignupStep.signup:
        return StepSignup(
          onSignupCompleted: (data) {
            setState(() {
              signupData = data;
            });
          },
          initialData: signupData.isNotEmpty ? signupData : null,
        );
    }
  }

  Widget _buildButtonBar() {
    final isLastStep = currentStep.isLast;
    final isGenreStep = currentStep.canSkip;
    final signupState = ref.watch(signupViewModelProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.getBackground(context),
        border: Border(
          top: BorderSide(
            color: AppColors.getSurface(context),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Skip button
          if (isGenreStep)
            Expanded(
              child: SecondaryButton(
                text: context.l10n.skip,
                onPressed: () {
                  setState(() {
                    // Reset selection for current step
                    if (currentStep == SignupStep.genre) {
                      selectedGenres = [];
                    }
                    // Move to next step
                    currentStep = currentStep.next ?? SignupStep.signup;
                  });
                },
              ),
            ),

          if (isGenreStep) const SizedBox(width: 16),

          // Continue/Sign Up button
          Expanded(
            child: PrimaryButton(
              text: isLastStep ? context.l10n.signUp : context.l10n.continueText,
              onPressed: signupState.isLoading 
                  ? null 
                  : (isLastStep ? _handleSignUp : (_canProceedToNextStep() ? _nextStep : null)),
              backgroundColor: signupState.isLoading
                  ? AppColors.getSurface(context)
                  : (_canProceedToNextStep() 
                      ? AppColors.primary500 
                      : AppColors.getSurface(context)),
              textColor: signupState.isLoading
                  ? AppColors.getTextSecondary(context)
                  : (_canProceedToNextStep() 
                      ? AppColors.getText(context) 
                      : AppColors.getTextSecondary(context)),
            ),
          ),
        ],
      ),
    );
  }
}

