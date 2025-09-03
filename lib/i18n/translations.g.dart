/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 2
/// Strings: 322 (161 per locale)

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.en;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale with BaseAppLocale<AppLocale, Translations> {
	en(languageCode: 'en', build: Translations.build),
	vi(languageCode: 'vi', build: _TranslationsVi.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, Translations> build;

	/// Gets current instance managed by [LocaleSettings].
	Translations get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
Translations get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class TranslationProvider extends BaseTranslationProvider<AppLocale, Translations> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, Translations> of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	Translations get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, Translations> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale, {bool? listenToDeviceLocale = false}) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale setLocaleRaw(String rawLocale, {bool? listenToDeviceLocale = false}) => instance.setLocaleRaw(rawLocale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, Translations> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	// Translations
	late final _TranslationsAppEn app = _TranslationsAppEn._(_root);
	late final _TranslationsCommonEn common = _TranslationsCommonEn._(_root);
	late final _TranslationsAuthEn auth = _TranslationsAuthEn._(_root);
	late final _TranslationsWelcomeEn welcome = _TranslationsWelcomeEn._(_root);
	late final _TranslationsSettingsEn settings = _TranslationsSettingsEn._(_root);
	late final _TranslationsValidationEn validation = _TranslationsValidationEn._(_root);
	late final _TranslationsNavigationEn navigation = _TranslationsNavigationEn._(_root);
	late final _TranslationsSearchEn search = _TranslationsSearchEn._(_root);
	late final _TranslationsNotificationEn notification = _TranslationsNotificationEn._(_root);
	late final _TranslationsUtilsEn utils = _TranslationsUtilsEn._(_root);
}

// Path: app
class _TranslationsAppEn {
	_TranslationsAppEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'NoZie';
}

// Path: common
class _TranslationsCommonEn {
	_TranslationsCommonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get skip => 'Skip';
	String get continueText => 'Continue';
	String get confirm => 'Confirm';
	String get data => 'Data';
	String get save => 'Save';
	String get cancel => 'Cancel';
	String get next => 'Next';
	String get back => 'Back';
	String get done => 'Done';
}

// Path: auth
class _TranslationsAuthEn {
	_TranslationsAuthEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get login => 'Login';
	String get signIn => 'Sign In';
	String get signUp => 'Sign Up';
	String get email => 'Email';
	String get password => 'Password';
	String get username => 'Username';
	String get confirmPassword => 'Confirm Password';
	String get rememberMe => 'Remember me';
	late final _TranslationsAuthLoginScreenEn loginScreen = _TranslationsAuthLoginScreenEn._(_root);
	late final _TranslationsAuthForgotPasswordEn forgotPassword = _TranslationsAuthForgotPasswordEn._(_root);
	late final _TranslationsAuthRegisterEn register = _TranslationsAuthRegisterEn._(_root);
}

// Path: welcome
class _TranslationsWelcomeEn {
	_TranslationsWelcomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Welcome to NoZie 👋';
	String get titlePrefix => 'Welcome to ';
	String get description => 'Your personal movie companion. Get personalized recommendations, discover new films, and track your watchlist.';
	String get getStarted => 'Get Started';
	String get continueWithGoogle => 'Continue with Google';
	String get iAlreadyHaveAnAccount => 'I Already Have an Account';
	late final _TranslationsWelcomeSlidesEn slides = _TranslationsWelcomeSlidesEn._(_root);
}

// Path: settings
class _TranslationsSettingsEn {
	_TranslationsSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final _TranslationsSettingsLanguageEn language = _TranslationsSettingsLanguageEn._(_root);
	late final _TranslationsSettingsThemeEn theme = _TranslationsSettingsThemeEn._(_root);
}

// Path: validation
class _TranslationsValidationEn {
	_TranslationsValidationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final _TranslationsValidationGeneralEn general = _TranslationsValidationGeneralEn._(_root);
	late final _TranslationsValidationNameEn name = _TranslationsValidationNameEn._(_root);
	late final _TranslationsValidationPhoneEn phone = _TranslationsValidationPhoneEn._(_root);
	late final _TranslationsValidationDateOfBirthEn dateOfBirth = _TranslationsValidationDateOfBirthEn._(_root);
	late final _TranslationsValidationCountryEn country = _TranslationsValidationCountryEn._(_root);
	late final _TranslationsValidationUsernameEn username = _TranslationsValidationUsernameEn._(_root);
	late final _TranslationsValidationEmailEn email = _TranslationsValidationEmailEn._(_root);
	late final _TranslationsValidationPasswordEn password = _TranslationsValidationPasswordEn._(_root);
}

// Path: navigation
class _TranslationsNavigationEn {
	_TranslationsNavigationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get home => 'Home';
	String get discover => 'Discover';
	String get wishlist => 'Wishlist';
	String get purchase => 'Purchase';
	String get profile => 'Profile';
}

// Path: search
class _TranslationsSearchEn {
	_TranslationsSearchEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get searchMovies => 'Search movies, TV shows, actors...';
	String get popularSearches => 'Popular Searches';
	String get noResultsFound => 'No results found';
	String get tryDifferentKeywords => 'Try different keywords or check your spelling';
	String get all => 'All';
	String get movies => 'Movies';
	String get tvShows => 'TV Shows';
	String get actors => 'Actors';
}

// Path: notification
class _TranslationsNotificationEn {
	_TranslationsNotificationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get notifications => 'Notifications';
	String get showRead => 'Show read notifications';
	String get allMarkedAsRead => 'All notifications marked as read';
	String get all => 'All';
	String get movies => 'Movies';
	String get promotions => 'Promotions';
	String get updates => 'Updates';
	String get noNotifications => 'No notifications';
	String get youAreAllCaughtUp => 'You\'re all caught up!';
}

// Path: utils
class _TranslationsUtilsEn {
	_TranslationsUtilsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get itemsCount => '{count} items';
	String get helloUser => 'Hello, {name}!';
	String get counterText => '';
}

// Path: auth.loginScreen
class _TranslationsAuthLoginScreenEn {
	_TranslationsAuthLoginScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Hello there 👋';
	String get description => 'Please enter your username/email and password to sign in.';
	late final _TranslationsAuthLoginScreenPlaceholderEn placeholder = _TranslationsAuthLoginScreenPlaceholderEn._(_root);
}

// Path: auth.forgotPassword
class _TranslationsAuthForgotPasswordEn {
	_TranslationsAuthForgotPasswordEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Forgot Password 🔑';
	String get description => 'Enter your email address. We will send an OTP code for verification in the next step.';
	String get orContinueWith => 'or continue with';
	late final _TranslationsAuthForgotPasswordOtpEn otp = _TranslationsAuthForgotPasswordOtpEn._(_root);
	late final _TranslationsAuthForgotPasswordNewPasswordEn newPassword = _TranslationsAuthForgotPasswordNewPasswordEn._(_root);
}

// Path: auth.register
class _TranslationsAuthRegisterEn {
	_TranslationsAuthRegisterEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get createAccount => 'Create an Account';
	String get description => 'Enter your username, email & password. If you forget it, then you have to do forgot password.';
	late final _TranslationsAuthRegisterPlaceholderEn placeholder = _TranslationsAuthRegisterPlaceholderEn._(_root);
	String get registrationSuccessful => 'Registration successful!';
	late final _TranslationsAuthRegisterStepsEn steps = _TranslationsAuthRegisterStepsEn._(_root);
}

// Path: welcome.slides
class _TranslationsWelcomeSlidesEn {
	_TranslationsWelcomeSlidesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final _TranslationsWelcomeSlidesDiscoverEn discover = _TranslationsWelcomeSlidesDiscoverEn._(_root);
	late final _TranslationsWelcomeSlidesTrackEn track = _TranslationsWelcomeSlidesTrackEn._(_root);
	late final _TranslationsWelcomeSlidesCommunityEn community = _TranslationsWelcomeSlidesCommunityEn._(_root);
}

// Path: settings.language
class _TranslationsSettingsLanguageEn {
	_TranslationsSettingsLanguageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get vietnamese => 'Tiếng Việt';
	String get english => 'English';
}

// Path: settings.theme
class _TranslationsSettingsThemeEn {
	_TranslationsSettingsThemeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get system => 'System';
	String get light => 'Light';
	String get dark => 'Dark';
}

// Path: validation.general
class _TranslationsValidationGeneralEn {
	_TranslationsValidationGeneralEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get fillAllFields => 'Please fill in all fields.';
	String get required => 'This field is required.';
	String length({required Object length}) => 'The length must be ${length}.';
	String min({required Object length}) => 'The minimum length is ${length}.';
	String max({required Object length}) => 'The maximum length is ${length}.';
	String get regex => 'The field is invalid.';
	late final _TranslationsValidationGeneralCustomEn custom = _TranslationsValidationGeneralCustomEn._(_root);
}

// Path: validation.name
class _TranslationsValidationNameEn {
	_TranslationsValidationNameEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get required => 'Full name is required';
	String get minLength => 'Full name must be at least 2 characters';
}

// Path: validation.phone
class _TranslationsValidationPhoneEn {
	_TranslationsValidationPhoneEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get required => 'Phone number is required';
	String get minLength => 'Phone number must be at least 10 digits';
}

// Path: validation.dateOfBirth
class _TranslationsValidationDateOfBirthEn {
	_TranslationsValidationDateOfBirthEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get required => 'Date of birth is required';
}

// Path: validation.country
class _TranslationsValidationCountryEn {
	_TranslationsValidationCountryEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get required => 'Country is required';
}

// Path: validation.username
class _TranslationsValidationUsernameEn {
	_TranslationsValidationUsernameEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get required => 'Username is required';
	String get minLength => 'Username must be at least 3 characters';
	String get invalidChars => 'Username can only contain letters, numbers, and underscores';
}

// Path: validation.email
class _TranslationsValidationEmailEn {
	_TranslationsValidationEmailEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get required => 'Email is required';
	String get invalid => 'Please enter a valid email address';
}

// Path: validation.password
class _TranslationsValidationPasswordEn {
	_TranslationsValidationPasswordEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get required => 'Password is required';
	String get minLength => 'Password must be at least 8 characters';
	String get complexity => 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
	String get confirmRequired => 'Please confirm your password';
	String get mismatch => 'Passwords do not match';
}

// Path: auth.loginScreen.placeholder
class _TranslationsAuthLoginScreenPlaceholderEn {
	_TranslationsAuthLoginScreenPlaceholderEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get email => 'admin@ziet.dev';
	String get password => '●●●●●●●●●●●●';
}

// Path: auth.forgotPassword.otp
class _TranslationsAuthForgotPasswordOtpEn {
	_TranslationsAuthForgotPasswordOtpEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'You\'ve Got Mail 📩';
	String get description => 'We have sent the OTP verification code to your email address. Check your email and enter the code below.';
	String get didntReceiveCode => 'Didn\'t receive the code?';
	String get resendCode => 'Resend Code';
	String resendAfter({required Object seconds}) => 'You can resend after ${seconds}s';
}

// Path: auth.forgotPassword.newPassword
class _TranslationsAuthForgotPasswordNewPasswordEn {
	_TranslationsAuthForgotPasswordNewPasswordEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Create New Password 🔐';
	String get description => 'Enter your new password. If you forget it, then you have to do forgot password.';
}

// Path: auth.register.placeholder
class _TranslationsAuthRegisterPlaceholderEn {
	_TranslationsAuthRegisterPlaceholderEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get username => 'Enter your username';
	String get password => 'Enter your password';
	String get email => 'Enter your email address';
	String get confirmPassword => 'Confirm your password';
}

// Path: auth.register.steps
class _TranslationsAuthRegisterStepsEn {
	_TranslationsAuthRegisterStepsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get stepOf => 'Step {current} of {total}';
	String get contentForStep => 'Content for step {step}';
	late final _TranslationsAuthRegisterStepsGenderEn gender = _TranslationsAuthRegisterStepsGenderEn._(_root);
	late final _TranslationsAuthRegisterStepsAgeEn age = _TranslationsAuthRegisterStepsAgeEn._(_root);
	late final _TranslationsAuthRegisterStepsGenresEn genres = _TranslationsAuthRegisterStepsGenresEn._(_root);
	late final _TranslationsAuthRegisterStepsProfileEn profile = _TranslationsAuthRegisterStepsProfileEn._(_root);
}

// Path: welcome.slides.discover
class _TranslationsWelcomeSlidesDiscoverEn {
	_TranslationsWelcomeSlidesDiscoverEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Discover New Movies';
	String get description => 'Explore thousands of movies from different genres. Find hidden gems and trending films that match your taste.';
}

// Path: welcome.slides.track
class _TranslationsWelcomeSlidesTrackEn {
	_TranslationsWelcomeSlidesTrackEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Track Your Watchlist';
	String get description => 'Save movies you want to watch, mark what you\'ve seen, and get recommendations based on your preferences.';
}

// Path: welcome.slides.community
class _TranslationsWelcomeSlidesCommunityEn {
	_TranslationsWelcomeSlidesCommunityEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Join the Community';
	String get description => 'Connect with other movie lovers, share reviews, and discover what\'s trending in the film world.';
}

// Path: validation.general.custom
class _TranslationsValidationGeneralCustomEn {
	_TranslationsValidationGeneralCustomEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get password => 'The password must have characters, numbers.';
	String get username => 'The username must only contain lowercase letters (a-z), numbers (0-9), hyphens (-), and underscores (_).';
}

// Path: auth.register.steps.gender
class _TranslationsAuthRegisterStepsGenderEn {
	_TranslationsAuthRegisterStepsGenderEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get select => 'Select your gender';
	String get question => 'What is your gender?';
	String get description => 'Select gender for better content';
	late final _TranslationsAuthRegisterStepsGenderOptionsEn options = _TranslationsAuthRegisterStepsGenderOptionsEn._(_root);
	late final _TranslationsAuthRegisterStepsGenderChoicesEn choices = _TranslationsAuthRegisterStepsGenderChoicesEn._(_root);
}

// Path: auth.register.steps.age
class _TranslationsAuthRegisterStepsAgeEn {
	_TranslationsAuthRegisterStepsAgeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get select => 'Select your age';
	String get title => 'Choose your Age';
	String get description => 'Select age range for better content';
	late final _TranslationsAuthRegisterStepsAgeRangesEn ranges = _TranslationsAuthRegisterStepsAgeRangesEn._(_root);
}

// Path: auth.register.steps.genres
class _TranslationsAuthRegisterStepsGenresEn {
	_TranslationsAuthRegisterStepsGenresEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get select => 'Select your favorite genres';
	String get title => 'Choose the Movie Genre You Like';
	String get description => 'Select your preferred movie genre for better recommendation or you can skip it';
	late final _TranslationsAuthRegisterStepsGenresListEn list = _TranslationsAuthRegisterStepsGenresListEn._(_root);
}

// Path: auth.register.steps.profile
class _TranslationsAuthRegisterStepsProfileEn {
	_TranslationsAuthRegisterStepsProfileEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Complete Your Profile';
	String get infoTitle => 'Profile Information';
	String get accountTitle => 'Account Information';
	String get privacyNote => 'Don\'t worry, only you can see your personal data. No one else will be able to see it.';
	late final _TranslationsAuthRegisterStepsProfilePhotoEn photo = _TranslationsAuthRegisterStepsProfilePhotoEn._(_root);
	late final _TranslationsAuthRegisterStepsProfileFieldsEn fields = _TranslationsAuthRegisterStepsProfileFieldsEn._(_root);
}

// Path: auth.register.steps.gender.options
class _TranslationsAuthRegisterStepsGenderOptionsEn {
	_TranslationsAuthRegisterStepsGenderOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get male => 'Male';
	String get female => 'Female';
	String get other => 'Other';
	String get preferNotToSay => 'Prefer not to say';
}

// Path: auth.register.steps.gender.choices
class _TranslationsAuthRegisterStepsGenderChoicesEn {
	_TranslationsAuthRegisterStepsGenderChoicesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get iAmMale => 'I am male';
	String get iAmFemale => 'I am female';
	String get ratherNotToSay => 'Rather not to say';
}

// Path: auth.register.steps.age.ranges
class _TranslationsAuthRegisterStepsAgeRangesEn {
	_TranslationsAuthRegisterStepsAgeRangesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get age14to17 => '14-17';
	String get age18to24 => '18-24';
	String get age25to29 => '25-29';
	String get age30to34 => '30-34';
	String get age35to39 => '35-39';
	String get age40to44 => '40-44';
	String get age45to49 => '45-49';
	String get age50plus => '50+';
}

// Path: auth.register.steps.genres.list
class _TranslationsAuthRegisterStepsGenresListEn {
	_TranslationsAuthRegisterStepsGenresListEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get action => 'Action';
	String get adventure => 'Adventure';
	String get animation => 'Animation';
	String get comedy => 'Comedy';
	String get crime => 'Crime';
	String get documentary => 'Documentary';
	String get drama => 'Drama';
	String get family => 'Family';
	String get fantasy => 'Fantasy';
	String get horror => 'Horror';
	String get mystery => 'Mystery';
	String get romance => 'Romance';
	String get sciFi => 'Sci-Fi';
	String get thriller => 'Thriller';
	String get war => 'War';
	String get western => 'Western';
}

// Path: auth.register.steps.profile.photo
class _TranslationsAuthRegisterStepsProfilePhotoEn {
	_TranslationsAuthRegisterStepsProfilePhotoEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get add => 'Add Photo';
	String get tapToAdd => 'Tap to add profile picture';
}

// Path: auth.register.steps.profile.fields
class _TranslationsAuthRegisterStepsProfileFieldsEn {
	_TranslationsAuthRegisterStepsProfileFieldsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final _TranslationsAuthRegisterStepsProfileFieldsFullNameEn fullName = _TranslationsAuthRegisterStepsProfileFieldsFullNameEn._(_root);
	late final _TranslationsAuthRegisterStepsProfileFieldsPhoneNumberEn phoneNumber = _TranslationsAuthRegisterStepsProfileFieldsPhoneNumberEn._(_root);
	late final _TranslationsAuthRegisterStepsProfileFieldsDateOfBirthEn dateOfBirth = _TranslationsAuthRegisterStepsProfileFieldsDateOfBirthEn._(_root);
	late final _TranslationsAuthRegisterStepsProfileFieldsCountryEn country = _TranslationsAuthRegisterStepsProfileFieldsCountryEn._(_root);
}

// Path: auth.register.steps.profile.fields.fullName
class _TranslationsAuthRegisterStepsProfileFieldsFullNameEn {
	_TranslationsAuthRegisterStepsProfileFieldsFullNameEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get label => 'Full Name';
	String get placeholder => 'Enter your full name';
}

// Path: auth.register.steps.profile.fields.phoneNumber
class _TranslationsAuthRegisterStepsProfileFieldsPhoneNumberEn {
	_TranslationsAuthRegisterStepsProfileFieldsPhoneNumberEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get label => 'Phone Number';
	String get placeholder => 'Enter your phone number';
}

// Path: auth.register.steps.profile.fields.dateOfBirth
class _TranslationsAuthRegisterStepsProfileFieldsDateOfBirthEn {
	_TranslationsAuthRegisterStepsProfileFieldsDateOfBirthEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get label => 'Date of Birth';
	String get format => 'DD/MM/YYYY';
}

// Path: auth.register.steps.profile.fields.country
class _TranslationsAuthRegisterStepsProfileFieldsCountryEn {
	_TranslationsAuthRegisterStepsProfileFieldsCountryEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get label => 'Country';
	String get placeholder => 'Enter your country';
}

// Path: <root>
class _TranslationsVi extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_TranslationsVi.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.vi,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <vi>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	@override late final _TranslationsVi _root = this; // ignore: unused_field

	// Translations
	@override late final _TranslationsAppVi app = _TranslationsAppVi._(_root);
	@override late final _TranslationsCommonVi common = _TranslationsCommonVi._(_root);
	@override late final _TranslationsAuthVi auth = _TranslationsAuthVi._(_root);
	@override late final _TranslationsWelcomeVi welcome = _TranslationsWelcomeVi._(_root);
	@override late final _TranslationsSettingsVi settings = _TranslationsSettingsVi._(_root);
	@override late final _TranslationsValidationVi validation = _TranslationsValidationVi._(_root);
	@override late final _TranslationsNavigationVi navigation = _TranslationsNavigationVi._(_root);
	@override late final _TranslationsSearchVi search = _TranslationsSearchVi._(_root);
	@override late final _TranslationsNotificationVi notification = _TranslationsNotificationVi._(_root);
	@override late final _TranslationsUtilsVi utils = _TranslationsUtilsVi._(_root);
}

// Path: app
class _TranslationsAppVi extends _TranslationsAppEn {
	_TranslationsAppVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get title => 'NoZie';
}

// Path: common
class _TranslationsCommonVi extends _TranslationsCommonEn {
	_TranslationsCommonVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get skip => 'Bỏ qua';
	@override String get continueText => 'Tiếp tục';
	@override String get confirm => 'Xác nhận';
	@override String get data => 'Dữ liệu';
	@override String get save => 'Lưu';
	@override String get cancel => 'Hủy';
	@override String get next => 'Tiếp theo';
	@override String get back => 'Quay lại';
	@override String get done => 'Hoàn thành';
}

// Path: auth
class _TranslationsAuthVi extends _TranslationsAuthEn {
	_TranslationsAuthVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get login => 'Đăng nhập';
	@override String get signIn => 'Đăng Nhập';
	@override String get signUp => 'Đăng ký';
	@override String get email => 'Email';
	@override String get password => 'Mật khẩu';
	@override String get username => 'Tên đăng nhập';
	@override String get confirmPassword => 'Xác nhận mật khẩu';
	@override String get rememberMe => 'Ghi nhớ tôi';
	@override late final _TranslationsAuthLoginScreenVi loginScreen = _TranslationsAuthLoginScreenVi._(_root);
	@override late final _TranslationsAuthForgotPasswordVi forgotPassword = _TranslationsAuthForgotPasswordVi._(_root);
	@override late final _TranslationsAuthRegisterVi register = _TranslationsAuthRegisterVi._(_root);
}

// Path: welcome
class _TranslationsWelcomeVi extends _TranslationsWelcomeEn {
	_TranslationsWelcomeVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get title => 'Chào mừng đến với NoZie 👋';
	@override String get titlePrefix => 'Chào mừng đến với ';
	@override String get description => 'Người bạn đồng hành phim của bạn. Nhận gợi ý cá nhân hóa, khám phá phim mới và theo dõi danh sách xem của bạn.';
	@override String get getStarted => 'Bắt đầu';
	@override String get continueWithGoogle => 'Tiếp tục với Google';
	@override String get iAlreadyHaveAnAccount => 'Tôi đã có tài khoản';
	@override late final _TranslationsWelcomeSlidesVi slides = _TranslationsWelcomeSlidesVi._(_root);
}

// Path: settings
class _TranslationsSettingsVi extends _TranslationsSettingsEn {
	_TranslationsSettingsVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSettingsLanguageVi language = _TranslationsSettingsLanguageVi._(_root);
	@override late final _TranslationsSettingsThemeVi theme = _TranslationsSettingsThemeVi._(_root);
}

// Path: validation
class _TranslationsValidationVi extends _TranslationsValidationEn {
	_TranslationsValidationVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsValidationGeneralVi general = _TranslationsValidationGeneralVi._(_root);
	@override late final _TranslationsValidationNameVi name = _TranslationsValidationNameVi._(_root);
	@override late final _TranslationsValidationPhoneVi phone = _TranslationsValidationPhoneVi._(_root);
	@override late final _TranslationsValidationDateOfBirthVi dateOfBirth = _TranslationsValidationDateOfBirthVi._(_root);
	@override late final _TranslationsValidationCountryVi country = _TranslationsValidationCountryVi._(_root);
	@override late final _TranslationsValidationUsernameVi username = _TranslationsValidationUsernameVi._(_root);
	@override late final _TranslationsValidationEmailVi email = _TranslationsValidationEmailVi._(_root);
	@override late final _TranslationsValidationPasswordVi password = _TranslationsValidationPasswordVi._(_root);
}

// Path: navigation
class _TranslationsNavigationVi extends _TranslationsNavigationEn {
	_TranslationsNavigationVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get home => 'Trang chủ';
	@override String get discover => 'Khám phá';
	@override String get wishlist => 'Yêu thích';
	@override String get purchase => 'Mua';
	@override String get profile => 'Hồ sơ';
}

// Path: search
class _TranslationsSearchVi extends _TranslationsSearchEn {
	_TranslationsSearchVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get searchMovies => 'Tìm kiếm phim, chương trình TV, diễn viên...';
	@override String get popularSearches => 'Tìm kiếm phổ biến';
	@override String get noResultsFound => 'Không tìm thấy kết quả';
	@override String get tryDifferentKeywords => 'Thử từ khóa khác hoặc kiểm tra chính tả';
	@override String get all => 'Tất cả';
	@override String get movies => 'Phim';
	@override String get tvShows => 'Chương trình TV';
	@override String get actors => 'Diễn viên';
}

// Path: notification
class _TranslationsNotificationVi extends _TranslationsNotificationEn {
	_TranslationsNotificationVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get notifications => 'Thông báo';
	@override String get showRead => 'Hiển thị thông báo đã đọc';
	@override String get allMarkedAsRead => 'Đã đánh dấu tất cả thông báo là đã đọc';
	@override String get all => 'Tất cả';
	@override String get movies => 'Phim';
	@override String get promotions => 'Khuyến mãi';
	@override String get updates => 'Cập nhật';
	@override String get noNotifications => 'Không có thông báo';
	@override String get youAreAllCaughtUp => 'Bạn đã cập nhật tất cả!';
}

// Path: utils
class _TranslationsUtilsVi extends _TranslationsUtilsEn {
	_TranslationsUtilsVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get itemsCount => '{count, plural, =0{Không có mục} =1{1 mục} other{{count} mục}}';
	@override String get helloUser => 'Xin chào, {name}!';
	@override String get counterText => '';
}

// Path: auth.loginScreen
class _TranslationsAuthLoginScreenVi extends _TranslationsAuthLoginScreenEn {
	_TranslationsAuthLoginScreenVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get title => 'Xin chào bạn 👋';
	@override String get description => 'Điền email/tên đăng nhập và mật khẩu để tiếp tục nha ✨';
	@override late final _TranslationsAuthLoginScreenPlaceholderVi placeholder = _TranslationsAuthLoginScreenPlaceholderVi._(_root);
}

// Path: auth.forgotPassword
class _TranslationsAuthForgotPasswordVi extends _TranslationsAuthForgotPasswordEn {
	_TranslationsAuthForgotPasswordVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get title => 'Quên Mật Khẩu 🔑';
	@override String get description => 'Nhập email của bạn, chúng tôi sẽ gửi mã OTP để xác minh ở bước tiếp theo.';
	@override String get orContinueWith => 'hoặc tiếp tục với';
	@override late final _TranslationsAuthForgotPasswordOtpVi otp = _TranslationsAuthForgotPasswordOtpVi._(_root);
	@override late final _TranslationsAuthForgotPasswordNewPasswordVi newPassword = _TranslationsAuthForgotPasswordNewPasswordVi._(_root);
}

// Path: auth.register
class _TranslationsAuthRegisterVi extends _TranslationsAuthRegisterEn {
	_TranslationsAuthRegisterVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get createAccount => 'Tạo tài khoản';
	@override String get description => 'Nhập tên đăng nhập, email và mật khẩu. Nếu bạn quên, bạn sẽ phải làm quên mật khẩu.';
	@override late final _TranslationsAuthRegisterPlaceholderVi placeholder = _TranslationsAuthRegisterPlaceholderVi._(_root);
	@override String get registrationSuccessful => 'Đăng ký thành công!';
	@override late final _TranslationsAuthRegisterStepsVi steps = _TranslationsAuthRegisterStepsVi._(_root);
}

// Path: welcome.slides
class _TranslationsWelcomeSlidesVi extends _TranslationsWelcomeSlidesEn {
	_TranslationsWelcomeSlidesVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsWelcomeSlidesDiscoverVi discover = _TranslationsWelcomeSlidesDiscoverVi._(_root);
	@override late final _TranslationsWelcomeSlidesTrackVi track = _TranslationsWelcomeSlidesTrackVi._(_root);
	@override late final _TranslationsWelcomeSlidesCommunityVi community = _TranslationsWelcomeSlidesCommunityVi._(_root);
}

// Path: settings.language
class _TranslationsSettingsLanguageVi extends _TranslationsSettingsLanguageEn {
	_TranslationsSettingsLanguageVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get vietnamese => 'Tiếng Việt';
	@override String get english => 'English';
}

// Path: settings.theme
class _TranslationsSettingsThemeVi extends _TranslationsSettingsThemeEn {
	_TranslationsSettingsThemeVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get system => 'Hệ thống';
	@override String get light => 'Sáng';
	@override String get dark => 'Tối';
}

// Path: validation.general
class _TranslationsValidationGeneralVi extends _TranslationsValidationGeneralEn {
	_TranslationsValidationGeneralVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get fillAllFields => 'Vui lòng điền đầy đủ tất cả các trường.';
	@override String get required => 'Trường này là bắt buộc.';
	@override String length({required Object length}) => 'Độ dài phải là ${length}.';
	@override String min({required Object length}) => 'Độ dài tối thiểu là ${length}.';
	@override String max({required Object length}) => 'Độ dài tối đa là ${length}.';
	@override String get regex => 'Trường không hợp lệ.';
	@override late final _TranslationsValidationGeneralCustomVi custom = _TranslationsValidationGeneralCustomVi._(_root);
}

// Path: validation.name
class _TranslationsValidationNameVi extends _TranslationsValidationNameEn {
	_TranslationsValidationNameVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get required => 'Họ và tên là bắt buộc';
	@override String get minLength => 'Họ và tên phải có ít nhất 2 ký tự';
}

// Path: validation.phone
class _TranslationsValidationPhoneVi extends _TranslationsValidationPhoneEn {
	_TranslationsValidationPhoneVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get required => 'Số điện thoại là bắt buộc';
	@override String get minLength => 'Số điện thoại phải có ít nhất 10 chữ số';
}

// Path: validation.dateOfBirth
class _TranslationsValidationDateOfBirthVi extends _TranslationsValidationDateOfBirthEn {
	_TranslationsValidationDateOfBirthVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get required => 'Ngày sinh là bắt buộc';
}

// Path: validation.country
class _TranslationsValidationCountryVi extends _TranslationsValidationCountryEn {
	_TranslationsValidationCountryVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get required => 'Quốc gia là bắt buộc';
}

// Path: validation.username
class _TranslationsValidationUsernameVi extends _TranslationsValidationUsernameEn {
	_TranslationsValidationUsernameVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get required => 'Tên đăng nhập là bắt buộc';
	@override String get minLength => 'Tên đăng nhập phải có ít nhất 3 ký tự';
	@override String get invalidChars => 'Tên đăng nhập chỉ có thể chứa chữ cái, số và dấu gạch dưới';
}

// Path: validation.email
class _TranslationsValidationEmailVi extends _TranslationsValidationEmailEn {
	_TranslationsValidationEmailVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get required => 'Email là bắt buộc';
	@override String get invalid => 'Vui lòng nhập địa chỉ email hợp lệ';
}

// Path: validation.password
class _TranslationsValidationPasswordVi extends _TranslationsValidationPasswordEn {
	_TranslationsValidationPasswordVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get required => 'Mật khẩu là bắt buộc';
	@override String get minLength => 'Mật khẩu phải có ít nhất 8 ký tự';
	@override String get complexity => 'Mật khẩu phải chứa ít nhất một chữ hoa, một chữ thường và một số';
	@override String get confirmRequired => 'Vui lòng xác nhận mật khẩu của bạn';
	@override String get mismatch => 'Mật khẩu không khớp';
}

// Path: auth.loginScreen.placeholder
class _TranslationsAuthLoginScreenPlaceholderVi extends _TranslationsAuthLoginScreenPlaceholderEn {
	_TranslationsAuthLoginScreenPlaceholderVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get email => 'admin@ziet.dev';
	@override String get password => '●●●●●●●●●●●●';
}

// Path: auth.forgotPassword.otp
class _TranslationsAuthForgotPasswordOtpVi extends _TranslationsAuthForgotPasswordOtpEn {
	_TranslationsAuthForgotPasswordOtpVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get title => 'OTP tới rồi nè 📩';
	@override String get description => 'Chúng tôi đã gửi mã xác thực OTP đến email của bạn. Vui lòng kiểm tra email và nhập mã bên dưới nhé.';
	@override String get didntReceiveCode => 'Chưa có mã?';
	@override String get resendCode => 'Gửi lại mã ngay';
	@override String resendAfter({required Object seconds}) => 'Đợi ${seconds}s rồi gửi lại';
}

// Path: auth.forgotPassword.newPassword
class _TranslationsAuthForgotPasswordNewPasswordVi extends _TranslationsAuthForgotPasswordNewPasswordEn {
	_TranslationsAuthForgotPasswordNewPasswordVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tạo mật khẩu mới 🔐';
	@override String get description => 'Nhập mật khẩu mới của bạn. Nếu quên, bạn sẽ cần thực hiện lại bước quên mật khẩu.';
}

// Path: auth.register.placeholder
class _TranslationsAuthRegisterPlaceholderVi extends _TranslationsAuthRegisterPlaceholderEn {
	_TranslationsAuthRegisterPlaceholderVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get username => 'Nhập tên đăng nhập của bạn';
	@override String get password => 'Nhập mật khẩu của bạn';
	@override String get email => 'Nhập địa chỉ email của bạn';
	@override String get confirmPassword => 'Xác nhận mật khẩu của bạn';
}

// Path: auth.register.steps
class _TranslationsAuthRegisterStepsVi extends _TranslationsAuthRegisterStepsEn {
	_TranslationsAuthRegisterStepsVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get stepOf => 'Bước {current} của {total}';
	@override String get contentForStep => 'Nội dung cho bước {step}';
	@override late final _TranslationsAuthRegisterStepsGenderVi gender = _TranslationsAuthRegisterStepsGenderVi._(_root);
	@override late final _TranslationsAuthRegisterStepsAgeVi age = _TranslationsAuthRegisterStepsAgeVi._(_root);
	@override late final _TranslationsAuthRegisterStepsGenresVi genres = _TranslationsAuthRegisterStepsGenresVi._(_root);
	@override late final _TranslationsAuthRegisterStepsProfileVi profile = _TranslationsAuthRegisterStepsProfileVi._(_root);
}

// Path: welcome.slides.discover
class _TranslationsWelcomeSlidesDiscoverVi extends _TranslationsWelcomeSlidesDiscoverEn {
	_TranslationsWelcomeSlidesDiscoverVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get title => 'Khám phá phim mới';
	@override String get description => 'Khám phá hàng nghìn bộ phim từ các thể loại khác nhau. Tìm những viên ngọc ẩn và phim xu hướng phù hợp với sở thích của bạn.';
}

// Path: welcome.slides.track
class _TranslationsWelcomeSlidesTrackVi extends _TranslationsWelcomeSlidesTrackEn {
	_TranslationsWelcomeSlidesTrackVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get title => 'Theo dõi danh sách xem';
	@override String get description => 'Lưu phim bạn muốn xem, đánh dấu những gì bạn đã xem và nhận gợi ý dựa trên sở thích của bạn.';
}

// Path: welcome.slides.community
class _TranslationsWelcomeSlidesCommunityVi extends _TranslationsWelcomeSlidesCommunityEn {
	_TranslationsWelcomeSlidesCommunityVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tham gia cộng đồng';
	@override String get description => 'Kết nối với những người yêu phim khác, chia sẻ đánh giá và khám phá những gì đang xu hướng trong thế giới điện ảnh.';
}

// Path: validation.general.custom
class _TranslationsValidationGeneralCustomVi extends _TranslationsValidationGeneralCustomEn {
	_TranslationsValidationGeneralCustomVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get password => 'Mật khẩu phải có ký tự, số.';
	@override String get username => 'Tên người dùng chỉ được chứa chữ cái thường (a-z), số (0-9), dấu gạch ngang (-) và dấu gạch dưới (_).';
}

// Path: auth.register.steps.gender
class _TranslationsAuthRegisterStepsGenderVi extends _TranslationsAuthRegisterStepsGenderEn {
	_TranslationsAuthRegisterStepsGenderVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get select => 'Chọn giới tính của bạn';
	@override String get question => 'Giới tính của bạn là gì?';
	@override String get description => 'Chọn giới tính để có nội dung phù hợp hơn';
	@override late final _TranslationsAuthRegisterStepsGenderOptionsVi options = _TranslationsAuthRegisterStepsGenderOptionsVi._(_root);
	@override late final _TranslationsAuthRegisterStepsGenderChoicesVi choices = _TranslationsAuthRegisterStepsGenderChoicesVi._(_root);
}

// Path: auth.register.steps.age
class _TranslationsAuthRegisterStepsAgeVi extends _TranslationsAuthRegisterStepsAgeEn {
	_TranslationsAuthRegisterStepsAgeVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get select => 'Chọn độ tuổi của bạn';
	@override String get title => 'Chọn độ tuổi của bạn';
	@override String get description => 'Chọn khoảng tuổi để có nội dung phù hợp hơn';
	@override late final _TranslationsAuthRegisterStepsAgeRangesVi ranges = _TranslationsAuthRegisterStepsAgeRangesVi._(_root);
}

// Path: auth.register.steps.genres
class _TranslationsAuthRegisterStepsGenresVi extends _TranslationsAuthRegisterStepsGenresEn {
	_TranslationsAuthRegisterStepsGenresVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get select => 'Chọn thể loại yêu thích';
	@override String get title => 'Chọn thể loại phim bạn thích';
	@override String get description => 'Chọn thể loại phim yêu thích để có gợi ý tốt hơn hoặc bạn có thể bỏ qua';
	@override late final _TranslationsAuthRegisterStepsGenresListVi list = _TranslationsAuthRegisterStepsGenresListVi._(_root);
}

// Path: auth.register.steps.profile
class _TranslationsAuthRegisterStepsProfileVi extends _TranslationsAuthRegisterStepsProfileEn {
	_TranslationsAuthRegisterStepsProfileVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get title => 'Hoàn thành hồ sơ của bạn';
	@override String get infoTitle => 'Thông tin cá nhân';
	@override String get accountTitle => 'Thông tin tài khoản';
	@override String get privacyNote => 'Đừng lo lắng, chỉ bạn mới có thể xem dữ liệu cá nhân của mình. Không ai khác có thể xem được.';
	@override late final _TranslationsAuthRegisterStepsProfilePhotoVi photo = _TranslationsAuthRegisterStepsProfilePhotoVi._(_root);
	@override late final _TranslationsAuthRegisterStepsProfileFieldsVi fields = _TranslationsAuthRegisterStepsProfileFieldsVi._(_root);
}

// Path: auth.register.steps.gender.options
class _TranslationsAuthRegisterStepsGenderOptionsVi extends _TranslationsAuthRegisterStepsGenderOptionsEn {
	_TranslationsAuthRegisterStepsGenderOptionsVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get male => 'Nam';
	@override String get female => 'Nữ';
	@override String get other => 'Khác';
	@override String get preferNotToSay => 'Không muốn nói';
}

// Path: auth.register.steps.gender.choices
class _TranslationsAuthRegisterStepsGenderChoicesVi extends _TranslationsAuthRegisterStepsGenderChoicesEn {
	_TranslationsAuthRegisterStepsGenderChoicesVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get iAmMale => 'Tôi là nam';
	@override String get iAmFemale => 'Tôi là nữ';
	@override String get ratherNotToSay => 'Không muốn nói';
}

// Path: auth.register.steps.age.ranges
class _TranslationsAuthRegisterStepsAgeRangesVi extends _TranslationsAuthRegisterStepsAgeRangesEn {
	_TranslationsAuthRegisterStepsAgeRangesVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get age14to17 => '14-17';
	@override String get age18to24 => '18-24';
	@override String get age25to29 => '25-29';
	@override String get age30to34 => '30-34';
	@override String get age35to39 => '35-39';
	@override String get age40to44 => '40-44';
	@override String get age45to49 => '45-49';
	@override String get age50plus => '50+';
}

// Path: auth.register.steps.genres.list
class _TranslationsAuthRegisterStepsGenresListVi extends _TranslationsAuthRegisterStepsGenresListEn {
	_TranslationsAuthRegisterStepsGenresListVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get action => 'Hành động';
	@override String get adventure => 'Phiêu lưu';
	@override String get animation => 'Hoạt hình';
	@override String get comedy => 'Hài';
	@override String get crime => 'Tội phạm';
	@override String get documentary => 'Tài liệu';
	@override String get drama => 'Kịch tính';
	@override String get family => 'Gia đình';
	@override String get fantasy => 'Viễn tưởng';
	@override String get horror => 'Kinh dị';
	@override String get mystery => 'Bí ẩn';
	@override String get romance => 'Lãng mạn';
	@override String get sciFi => 'Khoa học viễn tưởng';
	@override String get thriller => 'Giật gân';
	@override String get war => 'Chiến tranh';
	@override String get western => 'Viễn Tây';
}

// Path: auth.register.steps.profile.photo
class _TranslationsAuthRegisterStepsProfilePhotoVi extends _TranslationsAuthRegisterStepsProfilePhotoEn {
	_TranslationsAuthRegisterStepsProfilePhotoVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get add => 'Thêm ảnh';
	@override String get tapToAdd => 'Nhấn để thêm ảnh đại diện';
}

// Path: auth.register.steps.profile.fields
class _TranslationsAuthRegisterStepsProfileFieldsVi extends _TranslationsAuthRegisterStepsProfileFieldsEn {
	_TranslationsAuthRegisterStepsProfileFieldsVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthRegisterStepsProfileFieldsFullNameVi fullName = _TranslationsAuthRegisterStepsProfileFieldsFullNameVi._(_root);
	@override late final _TranslationsAuthRegisterStepsProfileFieldsPhoneNumberVi phoneNumber = _TranslationsAuthRegisterStepsProfileFieldsPhoneNumberVi._(_root);
	@override late final _TranslationsAuthRegisterStepsProfileFieldsDateOfBirthVi dateOfBirth = _TranslationsAuthRegisterStepsProfileFieldsDateOfBirthVi._(_root);
	@override late final _TranslationsAuthRegisterStepsProfileFieldsCountryVi country = _TranslationsAuthRegisterStepsProfileFieldsCountryVi._(_root);
}

// Path: auth.register.steps.profile.fields.fullName
class _TranslationsAuthRegisterStepsProfileFieldsFullNameVi extends _TranslationsAuthRegisterStepsProfileFieldsFullNameEn {
	_TranslationsAuthRegisterStepsProfileFieldsFullNameVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get label => 'Họ và tên';
	@override String get placeholder => 'Nhập họ và tên của bạn';
}

// Path: auth.register.steps.profile.fields.phoneNumber
class _TranslationsAuthRegisterStepsProfileFieldsPhoneNumberVi extends _TranslationsAuthRegisterStepsProfileFieldsPhoneNumberEn {
	_TranslationsAuthRegisterStepsProfileFieldsPhoneNumberVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get label => 'Số điện thoại';
	@override String get placeholder => 'Nhập số điện thoại của bạn';
}

// Path: auth.register.steps.profile.fields.dateOfBirth
class _TranslationsAuthRegisterStepsProfileFieldsDateOfBirthVi extends _TranslationsAuthRegisterStepsProfileFieldsDateOfBirthEn {
	_TranslationsAuthRegisterStepsProfileFieldsDateOfBirthVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get label => 'Ngày sinh';
	@override String get format => 'DD/MM/YYYY';
}

// Path: auth.register.steps.profile.fields.country
class _TranslationsAuthRegisterStepsProfileFieldsCountryVi extends _TranslationsAuthRegisterStepsProfileFieldsCountryEn {
	_TranslationsAuthRegisterStepsProfileFieldsCountryVi._(_TranslationsVi root) : this._root = root, super._(root);

	@override final _TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get label => 'Quốc gia';
	@override String get placeholder => 'Nhập quốc gia của bạn';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'app.title': return 'NoZie';
			case 'common.skip': return 'Skip';
			case 'common.continueText': return 'Continue';
			case 'common.confirm': return 'Confirm';
			case 'common.data': return 'Data';
			case 'common.save': return 'Save';
			case 'common.cancel': return 'Cancel';
			case 'common.next': return 'Next';
			case 'common.back': return 'Back';
			case 'common.done': return 'Done';
			case 'auth.login': return 'Login';
			case 'auth.signIn': return 'Sign In';
			case 'auth.signUp': return 'Sign Up';
			case 'auth.email': return 'Email';
			case 'auth.password': return 'Password';
			case 'auth.username': return 'Username';
			case 'auth.confirmPassword': return 'Confirm Password';
			case 'auth.rememberMe': return 'Remember me';
			case 'auth.loginScreen.title': return 'Hello there 👋';
			case 'auth.loginScreen.description': return 'Please enter your username/email and password to sign in.';
			case 'auth.loginScreen.placeholder.email': return 'admin@ziet.dev';
			case 'auth.loginScreen.placeholder.password': return '●●●●●●●●●●●●';
			case 'auth.forgotPassword.title': return 'Forgot Password 🔑';
			case 'auth.forgotPassword.description': return 'Enter your email address. We will send an OTP code for verification in the next step.';
			case 'auth.forgotPassword.orContinueWith': return 'or continue with';
			case 'auth.forgotPassword.otp.title': return 'You\'ve Got Mail 📩';
			case 'auth.forgotPassword.otp.description': return 'We have sent the OTP verification code to your email address. Check your email and enter the code below.';
			case 'auth.forgotPassword.otp.didntReceiveCode': return 'Didn\'t receive the code?';
			case 'auth.forgotPassword.otp.resendCode': return 'Resend Code';
			case 'auth.forgotPassword.otp.resendAfter': return ({required Object seconds}) => 'You can resend after ${seconds}s';
			case 'auth.forgotPassword.newPassword.title': return 'Create New Password 🔐';
			case 'auth.forgotPassword.newPassword.description': return 'Enter your new password. If you forget it, then you have to do forgot password.';
			case 'auth.register.createAccount': return 'Create an Account';
			case 'auth.register.description': return 'Enter your username, email & password. If you forget it, then you have to do forgot password.';
			case 'auth.register.placeholder.username': return 'Enter your username';
			case 'auth.register.placeholder.password': return 'Enter your password';
			case 'auth.register.placeholder.email': return 'Enter your email address';
			case 'auth.register.placeholder.confirmPassword': return 'Confirm your password';
			case 'auth.register.registrationSuccessful': return 'Registration successful!';
			case 'auth.register.steps.stepOf': return 'Step {current} of {total}';
			case 'auth.register.steps.contentForStep': return 'Content for step {step}';
			case 'auth.register.steps.gender.select': return 'Select your gender';
			case 'auth.register.steps.gender.question': return 'What is your gender?';
			case 'auth.register.steps.gender.description': return 'Select gender for better content';
			case 'auth.register.steps.gender.options.male': return 'Male';
			case 'auth.register.steps.gender.options.female': return 'Female';
			case 'auth.register.steps.gender.options.other': return 'Other';
			case 'auth.register.steps.gender.options.preferNotToSay': return 'Prefer not to say';
			case 'auth.register.steps.gender.choices.iAmMale': return 'I am male';
			case 'auth.register.steps.gender.choices.iAmFemale': return 'I am female';
			case 'auth.register.steps.gender.choices.ratherNotToSay': return 'Rather not to say';
			case 'auth.register.steps.age.select': return 'Select your age';
			case 'auth.register.steps.age.title': return 'Choose your Age';
			case 'auth.register.steps.age.description': return 'Select age range for better content';
			case 'auth.register.steps.age.ranges.age14to17': return '14-17';
			case 'auth.register.steps.age.ranges.age18to24': return '18-24';
			case 'auth.register.steps.age.ranges.age25to29': return '25-29';
			case 'auth.register.steps.age.ranges.age30to34': return '30-34';
			case 'auth.register.steps.age.ranges.age35to39': return '35-39';
			case 'auth.register.steps.age.ranges.age40to44': return '40-44';
			case 'auth.register.steps.age.ranges.age45to49': return '45-49';
			case 'auth.register.steps.age.ranges.age50plus': return '50+';
			case 'auth.register.steps.genres.select': return 'Select your favorite genres';
			case 'auth.register.steps.genres.title': return 'Choose the Movie Genre You Like';
			case 'auth.register.steps.genres.description': return 'Select your preferred movie genre for better recommendation or you can skip it';
			case 'auth.register.steps.genres.list.action': return 'Action';
			case 'auth.register.steps.genres.list.adventure': return 'Adventure';
			case 'auth.register.steps.genres.list.animation': return 'Animation';
			case 'auth.register.steps.genres.list.comedy': return 'Comedy';
			case 'auth.register.steps.genres.list.crime': return 'Crime';
			case 'auth.register.steps.genres.list.documentary': return 'Documentary';
			case 'auth.register.steps.genres.list.drama': return 'Drama';
			case 'auth.register.steps.genres.list.family': return 'Family';
			case 'auth.register.steps.genres.list.fantasy': return 'Fantasy';
			case 'auth.register.steps.genres.list.horror': return 'Horror';
			case 'auth.register.steps.genres.list.mystery': return 'Mystery';
			case 'auth.register.steps.genres.list.romance': return 'Romance';
			case 'auth.register.steps.genres.list.sciFi': return 'Sci-Fi';
			case 'auth.register.steps.genres.list.thriller': return 'Thriller';
			case 'auth.register.steps.genres.list.war': return 'War';
			case 'auth.register.steps.genres.list.western': return 'Western';
			case 'auth.register.steps.profile.title': return 'Complete Your Profile';
			case 'auth.register.steps.profile.infoTitle': return 'Profile Information';
			case 'auth.register.steps.profile.accountTitle': return 'Account Information';
			case 'auth.register.steps.profile.privacyNote': return 'Don\'t worry, only you can see your personal data. No one else will be able to see it.';
			case 'auth.register.steps.profile.photo.add': return 'Add Photo';
			case 'auth.register.steps.profile.photo.tapToAdd': return 'Tap to add profile picture';
			case 'auth.register.steps.profile.fields.fullName.label': return 'Full Name';
			case 'auth.register.steps.profile.fields.fullName.placeholder': return 'Enter your full name';
			case 'auth.register.steps.profile.fields.phoneNumber.label': return 'Phone Number';
			case 'auth.register.steps.profile.fields.phoneNumber.placeholder': return 'Enter your phone number';
			case 'auth.register.steps.profile.fields.dateOfBirth.label': return 'Date of Birth';
			case 'auth.register.steps.profile.fields.dateOfBirth.format': return 'DD/MM/YYYY';
			case 'auth.register.steps.profile.fields.country.label': return 'Country';
			case 'auth.register.steps.profile.fields.country.placeholder': return 'Enter your country';
			case 'welcome.title': return 'Welcome to NoZie 👋';
			case 'welcome.titlePrefix': return 'Welcome to ';
			case 'welcome.description': return 'Your personal movie companion. Get personalized recommendations, discover new films, and track your watchlist.';
			case 'welcome.getStarted': return 'Get Started';
			case 'welcome.continueWithGoogle': return 'Continue with Google';
			case 'welcome.iAlreadyHaveAnAccount': return 'I Already Have an Account';
			case 'welcome.slides.discover.title': return 'Discover New Movies';
			case 'welcome.slides.discover.description': return 'Explore thousands of movies from different genres. Find hidden gems and trending films that match your taste.';
			case 'welcome.slides.track.title': return 'Track Your Watchlist';
			case 'welcome.slides.track.description': return 'Save movies you want to watch, mark what you\'ve seen, and get recommendations based on your preferences.';
			case 'welcome.slides.community.title': return 'Join the Community';
			case 'welcome.slides.community.description': return 'Connect with other movie lovers, share reviews, and discover what\'s trending in the film world.';
			case 'settings.language.vietnamese': return 'Tiếng Việt';
			case 'settings.language.english': return 'English';
			case 'settings.theme.system': return 'System';
			case 'settings.theme.light': return 'Light';
			case 'settings.theme.dark': return 'Dark';
			case 'validation.general.fillAllFields': return 'Please fill in all fields.';
			case 'validation.general.required': return 'This field is required.';
			case 'validation.general.length': return ({required Object length}) => 'The length must be ${length}.';
			case 'validation.general.min': return ({required Object length}) => 'The minimum length is ${length}.';
			case 'validation.general.max': return ({required Object length}) => 'The maximum length is ${length}.';
			case 'validation.general.regex': return 'The field is invalid.';
			case 'validation.general.custom.password': return 'The password must have characters, numbers.';
			case 'validation.general.custom.username': return 'The username must only contain lowercase letters (a-z), numbers (0-9), hyphens (-), and underscores (_).';
			case 'validation.name.required': return 'Full name is required';
			case 'validation.name.minLength': return 'Full name must be at least 2 characters';
			case 'validation.phone.required': return 'Phone number is required';
			case 'validation.phone.minLength': return 'Phone number must be at least 10 digits';
			case 'validation.dateOfBirth.required': return 'Date of birth is required';
			case 'validation.country.required': return 'Country is required';
			case 'validation.username.required': return 'Username is required';
			case 'validation.username.minLength': return 'Username must be at least 3 characters';
			case 'validation.username.invalidChars': return 'Username can only contain letters, numbers, and underscores';
			case 'validation.email.required': return 'Email is required';
			case 'validation.email.invalid': return 'Please enter a valid email address';
			case 'validation.password.required': return 'Password is required';
			case 'validation.password.minLength': return 'Password must be at least 8 characters';
			case 'validation.password.complexity': return 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
			case 'validation.password.confirmRequired': return 'Please confirm your password';
			case 'validation.password.mismatch': return 'Passwords do not match';
			case 'navigation.home': return 'Home';
			case 'navigation.discover': return 'Discover';
			case 'navigation.wishlist': return 'Wishlist';
			case 'navigation.purchase': return 'Purchase';
			case 'navigation.profile': return 'Profile';
			case 'search.searchMovies': return 'Search movies, TV shows, actors...';
			case 'search.popularSearches': return 'Popular Searches';
			case 'search.noResultsFound': return 'No results found';
			case 'search.tryDifferentKeywords': return 'Try different keywords or check your spelling';
			case 'search.all': return 'All';
			case 'search.movies': return 'Movies';
			case 'search.tvShows': return 'TV Shows';
			case 'search.actors': return 'Actors';
			case 'notification.notifications': return 'Notifications';
			case 'notification.showRead': return 'Show read notifications';
			case 'notification.allMarkedAsRead': return 'All notifications marked as read';
			case 'notification.all': return 'All';
			case 'notification.movies': return 'Movies';
			case 'notification.promotions': return 'Promotions';
			case 'notification.updates': return 'Updates';
			case 'notification.noNotifications': return 'No notifications';
			case 'notification.youAreAllCaughtUp': return 'You\'re all caught up!';
			case 'utils.itemsCount': return '{count} items';
			case 'utils.helloUser': return 'Hello, {name}!';
			case 'utils.counterText': return '';
			default: return null;
		}
	}
}

extension on _TranslationsVi {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'app.title': return 'NoZie';
			case 'common.skip': return 'Bỏ qua';
			case 'common.continueText': return 'Tiếp tục';
			case 'common.confirm': return 'Xác nhận';
			case 'common.data': return 'Dữ liệu';
			case 'common.save': return 'Lưu';
			case 'common.cancel': return 'Hủy';
			case 'common.next': return 'Tiếp theo';
			case 'common.back': return 'Quay lại';
			case 'common.done': return 'Hoàn thành';
			case 'auth.login': return 'Đăng nhập';
			case 'auth.signIn': return 'Đăng Nhập';
			case 'auth.signUp': return 'Đăng ký';
			case 'auth.email': return 'Email';
			case 'auth.password': return 'Mật khẩu';
			case 'auth.username': return 'Tên đăng nhập';
			case 'auth.confirmPassword': return 'Xác nhận mật khẩu';
			case 'auth.rememberMe': return 'Ghi nhớ tôi';
			case 'auth.loginScreen.title': return 'Xin chào bạn 👋';
			case 'auth.loginScreen.description': return 'Điền email/tên đăng nhập và mật khẩu để tiếp tục nha ✨';
			case 'auth.loginScreen.placeholder.email': return 'admin@ziet.dev';
			case 'auth.loginScreen.placeholder.password': return '●●●●●●●●●●●●';
			case 'auth.forgotPassword.title': return 'Quên Mật Khẩu 🔑';
			case 'auth.forgotPassword.description': return 'Nhập email của bạn, chúng tôi sẽ gửi mã OTP để xác minh ở bước tiếp theo.';
			case 'auth.forgotPassword.orContinueWith': return 'hoặc tiếp tục với';
			case 'auth.forgotPassword.otp.title': return 'OTP tới rồi nè 📩';
			case 'auth.forgotPassword.otp.description': return 'Chúng tôi đã gửi mã xác thực OTP đến email của bạn. Vui lòng kiểm tra email và nhập mã bên dưới nhé.';
			case 'auth.forgotPassword.otp.didntReceiveCode': return 'Chưa có mã?';
			case 'auth.forgotPassword.otp.resendCode': return 'Gửi lại mã ngay';
			case 'auth.forgotPassword.otp.resendAfter': return ({required Object seconds}) => 'Đợi ${seconds}s rồi gửi lại';
			case 'auth.forgotPassword.newPassword.title': return 'Tạo mật khẩu mới 🔐';
			case 'auth.forgotPassword.newPassword.description': return 'Nhập mật khẩu mới của bạn. Nếu quên, bạn sẽ cần thực hiện lại bước quên mật khẩu.';
			case 'auth.register.createAccount': return 'Tạo tài khoản';
			case 'auth.register.description': return 'Nhập tên đăng nhập, email và mật khẩu. Nếu bạn quên, bạn sẽ phải làm quên mật khẩu.';
			case 'auth.register.placeholder.username': return 'Nhập tên đăng nhập của bạn';
			case 'auth.register.placeholder.password': return 'Nhập mật khẩu của bạn';
			case 'auth.register.placeholder.email': return 'Nhập địa chỉ email của bạn';
			case 'auth.register.placeholder.confirmPassword': return 'Xác nhận mật khẩu của bạn';
			case 'auth.register.registrationSuccessful': return 'Đăng ký thành công!';
			case 'auth.register.steps.stepOf': return 'Bước {current} của {total}';
			case 'auth.register.steps.contentForStep': return 'Nội dung cho bước {step}';
			case 'auth.register.steps.gender.select': return 'Chọn giới tính của bạn';
			case 'auth.register.steps.gender.question': return 'Giới tính của bạn là gì?';
			case 'auth.register.steps.gender.description': return 'Chọn giới tính để có nội dung phù hợp hơn';
			case 'auth.register.steps.gender.options.male': return 'Nam';
			case 'auth.register.steps.gender.options.female': return 'Nữ';
			case 'auth.register.steps.gender.options.other': return 'Khác';
			case 'auth.register.steps.gender.options.preferNotToSay': return 'Không muốn nói';
			case 'auth.register.steps.gender.choices.iAmMale': return 'Tôi là nam';
			case 'auth.register.steps.gender.choices.iAmFemale': return 'Tôi là nữ';
			case 'auth.register.steps.gender.choices.ratherNotToSay': return 'Không muốn nói';
			case 'auth.register.steps.age.select': return 'Chọn độ tuổi của bạn';
			case 'auth.register.steps.age.title': return 'Chọn độ tuổi của bạn';
			case 'auth.register.steps.age.description': return 'Chọn khoảng tuổi để có nội dung phù hợp hơn';
			case 'auth.register.steps.age.ranges.age14to17': return '14-17';
			case 'auth.register.steps.age.ranges.age18to24': return '18-24';
			case 'auth.register.steps.age.ranges.age25to29': return '25-29';
			case 'auth.register.steps.age.ranges.age30to34': return '30-34';
			case 'auth.register.steps.age.ranges.age35to39': return '35-39';
			case 'auth.register.steps.age.ranges.age40to44': return '40-44';
			case 'auth.register.steps.age.ranges.age45to49': return '45-49';
			case 'auth.register.steps.age.ranges.age50plus': return '50+';
			case 'auth.register.steps.genres.select': return 'Chọn thể loại yêu thích';
			case 'auth.register.steps.genres.title': return 'Chọn thể loại phim bạn thích';
			case 'auth.register.steps.genres.description': return 'Chọn thể loại phim yêu thích để có gợi ý tốt hơn hoặc bạn có thể bỏ qua';
			case 'auth.register.steps.genres.list.action': return 'Hành động';
			case 'auth.register.steps.genres.list.adventure': return 'Phiêu lưu';
			case 'auth.register.steps.genres.list.animation': return 'Hoạt hình';
			case 'auth.register.steps.genres.list.comedy': return 'Hài';
			case 'auth.register.steps.genres.list.crime': return 'Tội phạm';
			case 'auth.register.steps.genres.list.documentary': return 'Tài liệu';
			case 'auth.register.steps.genres.list.drama': return 'Kịch tính';
			case 'auth.register.steps.genres.list.family': return 'Gia đình';
			case 'auth.register.steps.genres.list.fantasy': return 'Viễn tưởng';
			case 'auth.register.steps.genres.list.horror': return 'Kinh dị';
			case 'auth.register.steps.genres.list.mystery': return 'Bí ẩn';
			case 'auth.register.steps.genres.list.romance': return 'Lãng mạn';
			case 'auth.register.steps.genres.list.sciFi': return 'Khoa học viễn tưởng';
			case 'auth.register.steps.genres.list.thriller': return 'Giật gân';
			case 'auth.register.steps.genres.list.war': return 'Chiến tranh';
			case 'auth.register.steps.genres.list.western': return 'Viễn Tây';
			case 'auth.register.steps.profile.title': return 'Hoàn thành hồ sơ của bạn';
			case 'auth.register.steps.profile.infoTitle': return 'Thông tin cá nhân';
			case 'auth.register.steps.profile.accountTitle': return 'Thông tin tài khoản';
			case 'auth.register.steps.profile.privacyNote': return 'Đừng lo lắng, chỉ bạn mới có thể xem dữ liệu cá nhân của mình. Không ai khác có thể xem được.';
			case 'auth.register.steps.profile.photo.add': return 'Thêm ảnh';
			case 'auth.register.steps.profile.photo.tapToAdd': return 'Nhấn để thêm ảnh đại diện';
			case 'auth.register.steps.profile.fields.fullName.label': return 'Họ và tên';
			case 'auth.register.steps.profile.fields.fullName.placeholder': return 'Nhập họ và tên của bạn';
			case 'auth.register.steps.profile.fields.phoneNumber.label': return 'Số điện thoại';
			case 'auth.register.steps.profile.fields.phoneNumber.placeholder': return 'Nhập số điện thoại của bạn';
			case 'auth.register.steps.profile.fields.dateOfBirth.label': return 'Ngày sinh';
			case 'auth.register.steps.profile.fields.dateOfBirth.format': return 'DD/MM/YYYY';
			case 'auth.register.steps.profile.fields.country.label': return 'Quốc gia';
			case 'auth.register.steps.profile.fields.country.placeholder': return 'Nhập quốc gia của bạn';
			case 'welcome.title': return 'Chào mừng đến với NoZie 👋';
			case 'welcome.titlePrefix': return 'Chào mừng đến với ';
			case 'welcome.description': return 'Người bạn đồng hành phim của bạn. Nhận gợi ý cá nhân hóa, khám phá phim mới và theo dõi danh sách xem của bạn.';
			case 'welcome.getStarted': return 'Bắt đầu';
			case 'welcome.continueWithGoogle': return 'Tiếp tục với Google';
			case 'welcome.iAlreadyHaveAnAccount': return 'Tôi đã có tài khoản';
			case 'welcome.slides.discover.title': return 'Khám phá phim mới';
			case 'welcome.slides.discover.description': return 'Khám phá hàng nghìn bộ phim từ các thể loại khác nhau. Tìm những viên ngọc ẩn và phim xu hướng phù hợp với sở thích của bạn.';
			case 'welcome.slides.track.title': return 'Theo dõi danh sách xem';
			case 'welcome.slides.track.description': return 'Lưu phim bạn muốn xem, đánh dấu những gì bạn đã xem và nhận gợi ý dựa trên sở thích của bạn.';
			case 'welcome.slides.community.title': return 'Tham gia cộng đồng';
			case 'welcome.slides.community.description': return 'Kết nối với những người yêu phim khác, chia sẻ đánh giá và khám phá những gì đang xu hướng trong thế giới điện ảnh.';
			case 'settings.language.vietnamese': return 'Tiếng Việt';
			case 'settings.language.english': return 'English';
			case 'settings.theme.system': return 'Hệ thống';
			case 'settings.theme.light': return 'Sáng';
			case 'settings.theme.dark': return 'Tối';
			case 'validation.general.fillAllFields': return 'Vui lòng điền đầy đủ tất cả các trường.';
			case 'validation.general.required': return 'Trường này là bắt buộc.';
			case 'validation.general.length': return ({required Object length}) => 'Độ dài phải là ${length}.';
			case 'validation.general.min': return ({required Object length}) => 'Độ dài tối thiểu là ${length}.';
			case 'validation.general.max': return ({required Object length}) => 'Độ dài tối đa là ${length}.';
			case 'validation.general.regex': return 'Trường không hợp lệ.';
			case 'validation.general.custom.password': return 'Mật khẩu phải có ký tự, số.';
			case 'validation.general.custom.username': return 'Tên người dùng chỉ được chứa chữ cái thường (a-z), số (0-9), dấu gạch ngang (-) và dấu gạch dưới (_).';
			case 'validation.name.required': return 'Họ và tên là bắt buộc';
			case 'validation.name.minLength': return 'Họ và tên phải có ít nhất 2 ký tự';
			case 'validation.phone.required': return 'Số điện thoại là bắt buộc';
			case 'validation.phone.minLength': return 'Số điện thoại phải có ít nhất 10 chữ số';
			case 'validation.dateOfBirth.required': return 'Ngày sinh là bắt buộc';
			case 'validation.country.required': return 'Quốc gia là bắt buộc';
			case 'validation.username.required': return 'Tên đăng nhập là bắt buộc';
			case 'validation.username.minLength': return 'Tên đăng nhập phải có ít nhất 3 ký tự';
			case 'validation.username.invalidChars': return 'Tên đăng nhập chỉ có thể chứa chữ cái, số và dấu gạch dưới';
			case 'validation.email.required': return 'Email là bắt buộc';
			case 'validation.email.invalid': return 'Vui lòng nhập địa chỉ email hợp lệ';
			case 'validation.password.required': return 'Mật khẩu là bắt buộc';
			case 'validation.password.minLength': return 'Mật khẩu phải có ít nhất 8 ký tự';
			case 'validation.password.complexity': return 'Mật khẩu phải chứa ít nhất một chữ hoa, một chữ thường và một số';
			case 'validation.password.confirmRequired': return 'Vui lòng xác nhận mật khẩu của bạn';
			case 'validation.password.mismatch': return 'Mật khẩu không khớp';
			case 'navigation.home': return 'Trang chủ';
			case 'navigation.discover': return 'Khám phá';
			case 'navigation.wishlist': return 'Yêu thích';
			case 'navigation.purchase': return 'Mua';
			case 'navigation.profile': return 'Hồ sơ';
			case 'search.searchMovies': return 'Tìm kiếm phim, chương trình TV, diễn viên...';
			case 'search.popularSearches': return 'Tìm kiếm phổ biến';
			case 'search.noResultsFound': return 'Không tìm thấy kết quả';
			case 'search.tryDifferentKeywords': return 'Thử từ khóa khác hoặc kiểm tra chính tả';
			case 'search.all': return 'Tất cả';
			case 'search.movies': return 'Phim';
			case 'search.tvShows': return 'Chương trình TV';
			case 'search.actors': return 'Diễn viên';
			case 'notification.notifications': return 'Thông báo';
			case 'notification.showRead': return 'Hiển thị thông báo đã đọc';
			case 'notification.allMarkedAsRead': return 'Đã đánh dấu tất cả thông báo là đã đọc';
			case 'notification.all': return 'Tất cả';
			case 'notification.movies': return 'Phim';
			case 'notification.promotions': return 'Khuyến mãi';
			case 'notification.updates': return 'Cập nhật';
			case 'notification.noNotifications': return 'Không có thông báo';
			case 'notification.youAreAllCaughtUp': return 'Bạn đã cập nhật tất cả!';
			case 'utils.itemsCount': return '{count, plural, =0{Không có mục} =1{1 mục} other{{count} mục}}';
			case 'utils.helloUser': return 'Xin chào, {name}!';
			case 'utils.counterText': return '';
			default: return null;
		}
	}
}
