import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import '../../../../core/util/image_constant.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import 'data/welcome_constant.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _currentBgIndex = 0;
  Timer? _bgTimer;

  final List<String> _backgroundImages = WelcomeBackgroundImages.images;
  final List<WelcomeSlide> _welcomeData = WelcomeData.slides;

  @override
  void initState() {
    super.initState();
    _startBackgroundAnimation();
  }

  void _startBackgroundAnimation() {
    _bgTimer = Timer.periodic(
      Duration(seconds: WelcomeAnimationValues.backgroundChangeInterval), 
      (timer) {
        if (mounted) {
          setState(() {
            _currentBgIndex = (_currentBgIndex + 1) % _backgroundImages.length;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bgTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;

    // Calculate responsive sizes
    final double topSpacing = screenHeight * WelcomeResponsiveValues.topSpacingRatio;
    final double horizontalPadding = screenWidth * WelcomeResponsiveValues.horizontalPaddingRatio;
    final double titleFontSize = screenWidth * WelcomeResponsiveValues.titleFontSizeRatio > WelcomeResponsiveValues.maxTitleFontSize 
        ? WelcomeResponsiveValues.maxTitleFontSize 
        : screenWidth * WelcomeResponsiveValues.titleFontSizeRatio;
    final double iconSize = screenWidth * WelcomeResponsiveValues.iconSizeRatio > WelcomeResponsiveValues.maxIconSize 
        ? WelcomeResponsiveValues.maxIconSize 
        : screenWidth * WelcomeResponsiveValues.iconSizeRatio;
    final double buttonHeight = screenHeight * WelcomeResponsiveValues.buttonHeightRatio;
    final double spaceBetween = screenHeight * WelcomeResponsiveValues.spaceBetweenRatio;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.dark1, AppColors.dark2],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image with AnimatedSwitcher
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: WelcomeAnimationValues.fadeTransitionDuration),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: Image.asset(
                  _backgroundImages[_currentBgIndex],
                  key: ValueKey<int>(_currentBgIndex),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: Colors.red);
                  },
                ),
              ),
            ),
            // Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: WelcomeGradientValues.overlayGradientStops,
                    colors: [
                      Colors.transparent,
                      AppColors.dark1.withValues(alpha: WelcomeGradientValues.overlayGradientAlpha[1]),
                      AppColors.dark1.withValues(alpha: WelcomeGradientValues.overlayGradientAlpha[2]),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                        children: [
                          // Top spacing
                          SizedBox(height: topSpacing * WelcomeResponsiveValues.topSpacingAdjustment),

                          // Welcome Text Section
                          Expanded(
                            flex: WelcomeResponsiveValues.welcomeContentFlex,
                            child: Column(
                              children: [
                                // Horizontal Scroll View
                                Expanded(
                                  child: PageView.builder(
                                    controller: _pageController,
                                    onPageChanged: (index) {
                                      setState(() {
                                        _currentPage = index;
                                      });
                                    },
                                    itemCount: _welcomeData.length,
                                    itemBuilder: (context, index) {
                                      final data = _welcomeData[index];
                                      return Padding(
                                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding * 0.5),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // Welcome Title
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  style: AppTypography.h3.copyWith(
                                                    color: AppColors.white,
                                                    fontSize: titleFontSize,
                                                  ),
                                                  children: [
                                                    if (data.title.contains('NoZie'))
                                                      ...[
                                                        const TextSpan(text: 'Welcome to '),
                                                        TextSpan(
                                                          text: 'NoZie 👋',
                                                          style: AppTypography.h3.copyWith(
                                                            color: AppColors.primary500,
                                                            fontSize: titleFontSize,
                                                          ),
                                                        ),
                                                      ]
                                                    else
                                                      TextSpan(text: data.title),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            SizedBox(height: spaceBetween),

                                            // Description
                                            Text(
                                              data.description,
                                              style: AppTypography.bodyLRegular.copyWith(
                                                color: AppColors.greyscale400,
                                                height: WelcomeResponsiveValues.descriptionLineHeight,
                                                fontSize: titleFontSize * WelcomeResponsiveValues.descriptionFontSizeRatio,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: WelcomeResponsiveValues.maxDescriptionLines,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                // Page Indicator
                                SizedBox(height: spaceBetween * WelcomeResponsiveValues.pageIndicatorSpacingRatio),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    _welcomeData.length,
                                    (index) => Container(
                                      width: screenWidth * WelcomeResponsiveValues.pageIndicatorWidthRatio,
                                      height: screenWidth * WelcomeResponsiveValues.pageIndicatorHeightRatio,
                                      margin: EdgeInsets.symmetric(horizontal: screenWidth * WelcomeResponsiveValues.pageIndicatorMarginRatio),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _currentPage == index
                                            ? AppColors.primary500
                                            : AppColors.greyscale400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Action Buttons Section
                          Expanded(
                            flex: WelcomeResponsiveValues.actionsAreaFlex,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Continue with Google
                                SizedBox(
                                  height: buttonHeight,
                                  child: PrimaryButton(
                                    text: WelcomeButtonTexts.googleText,
                                    onPressed: () {
                                      // TODO: Handle Google sign in
                                    },
                                    backgroundColor: AppColors.white,
                                    textColor: AppColors.greyscale900,
                                    hasShadow: true,
                                    icon: SvgPicture.asset(
                                      ImageConstant.imgGoogleIcon,
                                      width: iconSize,
                                      height: iconSize,
                                    ),
                                  ),
                                ),

                                SizedBox(height: spaceBetween),

                                // Get Started Button
                                SizedBox(
                                  height: buttonHeight,
                                  child: PrimaryButton(
                                    text: WelcomeButtonTexts.signUpText,
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/signup');
                                    },
                                    backgroundColor: AppColors.primary500,
                                    textColor: AppColors.white,
                                  ),
                                ),

                                SizedBox(height: spaceBetween),

                                // Sign In Button
                                SizedBox(
                                  height: buttonHeight,
                                  child: PrimaryButton(
                                    text: WelcomeButtonTexts.loginText,
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/login');
                                    },
                                    backgroundColor: AppColors.primary100,
                                    textColor: AppColors.primary500,
                                  ),
                                ),

                                // Bottom spacing
                                SizedBox(height: screenHeight * WelcomeResponsiveValues.bottomSpacingRatio),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}