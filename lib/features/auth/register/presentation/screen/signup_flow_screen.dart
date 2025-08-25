import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_fe/core/widgets/modal.dart';
import '../../../../../core/app_export.dart';
import '../../../../../core/common/ui_state.dart';
import '../viewmodel/signup_viewmodel.dart';
import '../models/signup_step.dart';
import '../../domain/entities/user_registration.dart';
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

  bool _canNextStep() {
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

  Future<void> _handleSignUp() async {
    final signupViewModel = ref.read(signupViewModelProvider.notifier);

    // Show loading dialog (SVG spinner), no buttons
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                ImageConstant.loadingIcon,
                width: 141,
                height: 141,
                colorFilter: ColorFilter.mode(
                  AppColors.primary500,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Processing...',
                style: AppTypography.bodyLRegular.copyWith(
                  color: AppColors.getTextSecondary(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final result = await signupViewModel.registerUser(
      gender: selectedGender,
      age: selectedAge,
      genres: selectedGenres,
      profileData: profileData,
      accountData: signupData,
    );

    if (mounted) Navigator.of(context).pop(); // close loading

    switch (result) {
      case Success<UserReg>(data: final _):
        if (!mounted) return;
        await showAppModal(
          context: context,
          title: 'Success',
          description: context.l10n.registrationSuccessful,
          iconPath: ImageConstant.successIcon,
          primaryButton: PrimaryButton(
            text: 'OK',
            onPressed: () => Navigator.pop(context),
          ),
        );
        break;
      case Error<UserReg>(message: final msg):
        if (!mounted) return;
        await showAppModal(
          context: context,
          title: 'Error',
          description: 'Error',
          iconPath: ImageConstant.successIcon,
          primaryButton: PrimaryButton(
            text: 'Close',
            onPressed: () => Navigator.pop(context),
          ),
          secondaryButton: SecondaryButton(
            text: 'ok',
            onPressed: () => Navigator.pop(context),
          ),
        );
        break;
      case Loading<UserReg>():
      case Idle<UserReg>():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildProcessBar(),

            Expanded(child: _buildStepContent()),

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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barWidth = (constraints.maxWidth * 0.5).clamp(
                  160.0,
                  320.0,
                ); // %50
                return SizedBox(
                  width: barWidth,
                  height: 12,
                  child: Stack(
                    children: [
                      Container(
                        decoration: ShapeDecoration(
                          color: AppColors.getSurface(context),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),

                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        width: barWidth * progress,
                        decoration: ShapeDecoration(
                          color: AppColors.primary500,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // <-
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                if (currentStep.isFirst) {
                  Navigator.pop(context);
                } else {
                  _previousStep();
                }
              },
              child: SizedBox(
                width: 16,
                height: 16,
                child: SvgPicture.asset(
                  ImageConstant.arrowIcon,
                  colorFilter: ColorFilter.mode(
                    AppColors.getText(context),
                    BlendMode.srcIn,
                  ),
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
          top: BorderSide(color: AppColors.getSurface(context), width: 1),
        ),
      ),
      child: Row(
        children: [
          if (isGenreStep)
            Expanded(
              child: SecondaryButton(
                text: context.l10n.skip,
                onPressed: () {
                  setState(() {
                    if (currentStep == SignupStep.genre) {
                      selectedGenres = [];
                    }
                    currentStep = currentStep.next ?? SignupStep.signup;
                  });
                },
              ),
            ),

          if (isGenreStep) const SizedBox(width: 16),

          Expanded(
            child: PrimaryButton(
              text: isLastStep
                  ? context.l10n.signUp
                  : context.l10n.continueText,
              onPressed: isLastStep
                  ? _handleSignUp
                  : (_canNextStep() ? _nextStep : null),
              backgroundColor: (_canNextStep()
                  ? AppColors.primary500
                  : AppColors.getSurface(context)),
            ),
          ),
        ],
      ),
    );
  }
}
