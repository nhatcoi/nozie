// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'NoZie';

  @override
  String get forgotPasswordTitle => 'Forgot Password 🔑';

  @override
  String get forgotPasswordDes => 'Enter your email address. We will send an OTP code for verification in the next step.';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get orContinueWith => 'or continue with';

  @override
  String get otpTitle => 'You’ve Got Mail 📩';

  @override
  String get otpDes => 'We have sent the OTP verification code to your email address. Check your email and enter the code below.';

  @override
  String get createNewPassword => 'Create New Password 🔐';

  @override
  String get createNewPasswordDes => 'Enter your new password. If you forget it, then you have to do forgot password.';

  @override
  String get signIn => 'Sign In';

  @override
  String get confirm => 'Confirm';

  @override
  String get otpDidntReceiveCode => 'Didn\'t receive the code?';

  @override
  String get otpResendCode => 'Resend Code';

  @override
  String otpResendAfter(Object seconds) {
    return 'You can resend after ${seconds}s';
  }

  @override
  String get loginTitle => 'Hello there 👋';

  @override
  String get loginDescription => 'Please enter your username/email and password to sign in.';

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get fillAllFields => 'Please fill in all fields.';

  @override
  String itemsCount(num count) {
    return '$count items';
  }

  @override
  String helloUser(String name) {
    return 'Hello, $name!';
  }

  @override
  String get skip => 'Skip';

  @override
  String get continueText => 'Continue';

  @override
  String get signUp => 'Sign Up';

  @override
  String get registrationSuccessful => 'Registration successful!';

  @override
  String stepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String contentForStep(int step) {
    return 'Content for step $step';
  }

  @override
  String get selectGender => 'Select your gender';

  @override
  String get selectAge => 'Select your age';

  @override
  String get selectGenres => 'Select your favorite genres';

  @override
  String get profileInfo => 'Profile Information';

  @override
  String get accountInfo => 'Account Information';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get other => 'Other';

  @override
  String get preferNotToSay => 'Prefer not to say';

  @override
  String get chooseYourAge => 'Choose your Age';

  @override
  String get selectAgeRange => 'Select age range for better content';

  @override
  String get age14to17 => '14-17';

  @override
  String get age18to24 => '18-24';

  @override
  String get age25to29 => '25-29';

  @override
  String get age30to34 => '30-34';

  @override
  String get age35to39 => '35-39';

  @override
  String get age40to44 => '40-44';

  @override
  String get age45to49 => '45-49';

  @override
  String get age50plus => '50+';

  @override
  String get whatIsYourGender => 'What is your gender?';

  @override
  String get selectGenderForBetterContent => 'Select gender for better content';

  @override
  String get iAmMale => 'I am male';

  @override
  String get iAmFemale => 'I am female';

  @override
  String get ratherNotToSay => 'Rather not to say';

  @override
  String get chooseMovieGenre => 'Choose the Movie Genre You Like';

  @override
  String get selectPreferredGenre => 'Select your preferred movie genre for better recommendation or you can skip it';

  @override
  String get action => 'Action';

  @override
  String get adventure => 'Adventure';

  @override
  String get animation => 'Animation';

  @override
  String get comedy => 'Comedy';

  @override
  String get crime => 'Crime';

  @override
  String get documentary => 'Documentary';

  @override
  String get drama => 'Drama';

  @override
  String get family => 'Family';

  @override
  String get fantasy => 'Fantasy';

  @override
  String get horror => 'Horror';

  @override
  String get mystery => 'Mystery';

  @override
  String get romance => 'Romance';

  @override
  String get sciFi => 'Sci-Fi';

  @override
  String get thriller => 'Thriller';

  @override
  String get war => 'War';

  @override
  String get western => 'Western';

  @override
  String get completeYourProfile => 'Complete Your Profile';

  @override
  String get profilePrivacyNote => 'Don\'t worry, only you can see your personal data. No one else will be able to see it.';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get tapToAddProfilePicture => 'Tap to add profile picture';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterYourFullName => 'Enter your full name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get enterYourPhoneNumber => 'Enter your phone number';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get dateFormat => 'DD/MM/YYYY';

  @override
  String get country => 'Country';

  @override
  String get enterYourCountry => 'Enter your country';

  @override
  String get fullNameRequired => 'Full name is required';

  @override
  String get fullNameMinLength => 'Full name must be at least 2 characters';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get phoneMinLength => 'Phone number must be at least 10 digits';

  @override
  String get dobRequired => 'Date of birth is required';

  @override
  String get countryRequired => 'Country is required';

  @override
  String get createAnAccount => 'Create an Account';

  @override
  String get signupDescription => 'Enter your username, email & password. If you forget it, then you have to do forgot password.';

  @override
  String get username => 'Username';

  @override
  String get enterYourUsername => 'Enter your username';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get enterYourEmailAddress => 'Enter your email address';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmYourPassword => 'Confirm your password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get usernameRequired => 'Username is required';

  @override
  String get usernameMinLength => 'Username must be at least 3 characters';

  @override
  String get usernameInvalidChars => 'Username can only contain letters, numbers, and underscores';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Please enter a valid email address';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMinLength => 'Password must be at least 8 characters';

  @override
  String get passwordComplexity => 'Password must contain at least one uppercase letter, one lowercase letter, and one number';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get welcomeToNoZie => 'Welcome to NoZie 👋';

  @override
  String get welcomeTo => 'Welcome to ';

  @override
  String get welcomeDescription => 'Your personal movie companion. Get personalized recommendations, discover new films, and track your watchlist.';

  @override
  String get discoverNewMovies => 'Discover New Movies';

  @override
  String get discoverDescription => 'Explore thousands of movies from different genres. Find hidden gems and trending films that match your taste.';

  @override
  String get trackYourWatchlist => 'Track Your Watchlist';

  @override
  String get trackDescription => 'Save movies you want to watch, mark what you\'ve seen, and get recommendations based on your preferences.';

  @override
  String get joinTheCommunity => 'Join the Community';

  @override
  String get joinDescription => 'Connect with other movie lovers, share reviews, and discover what\'s trending in the film world.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get iAlreadyHaveAnAccount => 'I Already Have an Account';
}
