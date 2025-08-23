import '../../../../core/util/image_constant.dart';


// TODO: add i10n support
class WelcomeSlide {
  final String title;
  final String description;

  const WelcomeSlide({
    required this.title,
    required this.description,
  });


}

class WelcomeData {
  static const List<WelcomeSlide> slides = [
    WelcomeSlide(
      title: 'Welcome to NoZie 👋',
      description: 'Your personal movie companion. Get personalized recommendations, discover new films, and track your watchlist.',
    ),
    WelcomeSlide(
      title: 'Discover New Movies',
      description: 'Explore thousands of movies from different genres. Find hidden gems and trending films that match your taste.',
    ),
    WelcomeSlide(
      title: 'Track Your Watchlist',
      description: 'Save movies you want to watch, mark what you\'ve seen, and get recommendations based on your preferences.',
    ),
    WelcomeSlide(
      title: 'Join the Community',
      description: 'Connect with other movie lovers, share reviews, and discover what\'s trending in the film world.',
    ),
  ];
}

class WelcomeBackgroundImages {
  static final List<String> images = [
    ImageConstant.imgBackground1,
    ImageConstant.imgBackground2,
    ImageConstant.imgBackground3,
    ImageConstant.imgBackground4,
  ];
}

class WelcomeResponsiveValues {
  // Screen sizing ratios
  static const double topSpacingRatio = 0.35;
  static const double horizontalPaddingRatio = 0.06;
  static const double titleFontSizeRatio = 0.075;
  static const double iconSizeRatio = 0.06;
  static const double buttonHeightRatio = 0.065;
  static const double spaceBetweenRatio = 0.02;
  static const double bottomSpacingRatio = 0.04;
  
  // Font size caps
  static const double maxTitleFontSize = 32;
  static const double maxIconSize = 24;
  
  // Description text scaling
  static const double descriptionFontSizeRatio = 0.45;
  static const double descriptionLineHeight = 1.5;
  static const int maxDescriptionLines = 4;
  
  // Page indicator sizing
  static const double pageIndicatorWidthRatio = 0.02;
  static const double pageIndicatorHeightRatio = 0.02;
  static const double pageIndicatorMarginRatio = 0.01;
  
  // Layout flex ratios
  static const int welcomeContentFlex = 3;
  static const int actionsAreaFlex = 4;
  
  // Spacing adjustments
  static const double topSpacingAdjustment = 0.9;
  static const double pageIndicatorSpacingRatio = 0.5;
  static const double pageIndicatorBottomSpacing = 2.0;
}

class WelcomeAnimationValues {
  static const int backgroundChangeInterval = 12;
  static const int fadeTransitionDuration = 1200;
}

class WelcomeGradientValues {
  static const List<double> overlayGradientStops = [0.1, 0.6, 1.0];
  static const List<double> overlayGradientAlpha = [0.0, 0.8, 0.95];
}

class WelcomeButtonTexts {
  static const String signUpText = 'Get Started';
  static const String googleText = 'Continue with Google';
  static const String loginText = 'I Already Have an Account';
}
