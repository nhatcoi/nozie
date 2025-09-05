class ImageConstant {
  // base path
  static const String _basePath = 'lib/assets/images/';

  // sub paths
  static const String subPathWelcome = '${_basePath}welcome/';
  static const String subPathCommon = '${_basePath}common/';
  static const String subPathApp = '${_basePath}app/';
  static const String subPathIcon    = '${_basePath}icons/';
  static const String subPathIconAuth = '${subPathIcon}auth/';
  static const String subPathIconNavigation = '${subPathIcon}navigation/';
  static const String subPathIconCommon = '${subPathIcon}common/';
  static const String subPathIconAction = '${subPathIcon}action/';

  // Auth Icons
  static const String imgGoogleIcon = '${subPathIconAuth}icon_google.svg';
  static const String imgFBIcon = '${subPathIconAuth}icon_facebook.svg';

  // Navigation Icons
  static const String homeIcon = '${subPathIconNavigation}home.svg';
  static const String discoverIcon = '${subPathIconNavigation}discover.svg';
  static const String purchaseIcon = '${subPathIconNavigation}purchase.svg';
  static const String wishlistIcon = '${subPathIconNavigation}wishlist.svg';
  static const String profileIcon = '${subPathIconNavigation}profile.svg';

  // Common Icons
  static const String logoIcon = '${subPathIconCommon}icon_logo.svg';
  static const String successIcon = '${subPathIconCommon}icon_success.svg';
  static const String loadingIcon = '${subPathIconCommon}icon_loading.svg';
  static const String imgCheckedIcon = '${subPathIconCommon}checked.svg';
  static const String imgUncheckedIcon = '${subPathIconCommon}unchecked.svg';
  static const String scheduleIcon = '${subPathIconCommon}schedule.svg';
  static const String groupIcon = '${subPathIconCommon}Group.svg';

  // Action Icons
  static const String arrowIcon = '${subPathIconAction}arrow.svg';
  static const String dropdownIcon = '${subPathIconAction}dropdown.svg';
  static const String closeIcon = '${subPathIconAction}close.svg';
  static const String filterIcon = '${subPathIconAction}filter.svg';
  static const String moreCircleIcon = '${subPathIconAction}more_circle.svg';
  static const String searchIcon = '${subPathIconAction}search.svg';
  static const String bellIcon = '${subPathIconAction}bell.svg';


  // Common Images
  static const String imgImageNotFound = '${subPathCommon}placeholder.png';
  static const String imgAvatar = '${subPathCommon}avatar.png';
  static const String imgCard = '${subPathCommon}card.png';

  // App Images
  static const String imgLogoApp = '${subPathApp}logo_app.png';
  static const String imgWelcomeTransparent = '${subPathApp}welcome-transparent.png';

  // Welcome Images
  static const String imgBackground1 = '${subPathWelcome}background-1.png';
  static const String imgBackground2 = '${subPathWelcome}background-2.png';
  static const String imgBackground3 = '${subPathWelcome}background-3.png';
  static const String imgBackground4 = '${subPathWelcome}background-4.png';
}