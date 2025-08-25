import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_fe/routes/app_routers.dart';
import 'dart:async';
import 'package:movie_fe/core/app_export.dart';
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.getBackground(context),
              AppColors.getSurface(context),
            ],
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
                      AppColors.getBackground(context).withValues(alpha: WelcomeGradientValues.overlayGradientAlpha[1]),
                      AppColors.getBackground(context).withValues(alpha: WelcomeGradientValues.overlayGradientAlpha[2]),
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
                                                    color: AppColors.getText(context),
                                                    fontSize: titleFontSize,
                                                  ),
                                                  children: [
                                                    if (data.titleKey == 'welcomeToNoZie')
                                                      ...[
                                                        TextSpan(text: context.l10n.welcomeTo),
                                                        TextSpan(
                                                          text: 'NoZie 👋',
                                                          style: AppTypography.h3.copyWith(
                                                            color: AppColors.primary500,
                                                            fontSize: titleFontSize,
                                                          ),
                                                        ),
                                                      ]
                                                    else
                                                      TextSpan(text: data.getTitle(context)),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            SizedBox(height: spaceBetween),

                                            // Description
                                            Text(
                                              data.getDescription(context),
                                              style: AppTypography.bodyLRegular.copyWith(
                                                color: AppColors.getTextSecondary(context),
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
                                            : AppColors.getTextSecondary(context),
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
                                    text: WelcomeButtonTexts.getGoogleText(context),
                                    onPressed: () {
                                      // TODO: Handle Google sign in
                                    },
                                    backgroundColor: AppColors.getSurface(context),
                                    textColor: AppColors.getText(context),
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
                                    text: WelcomeButtonTexts.getSignUpText(context),
                                    onPressed: () {
                                      Navigator.pushNamed(context, AppRouters.signup);
                                    },

                                  ),
                                ),

                                SizedBox(height: spaceBetween),

                                // Sign In Button
                                SizedBox(
                                  height: buttonHeight,
                                  child: SecondaryButton(
                                    text: WelcomeButtonTexts.getLoginText(context),
                                    onPressed: () {
                                      Navigator.pushNamed(context, AppRouters.login);
                                    },
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