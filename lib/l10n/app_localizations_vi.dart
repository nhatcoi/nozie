// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'NoZie';

  @override
  String get login => 'Đăng nhập';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String get themeLight => 'Sáng';

  @override
  String get themeDark => 'Tối';

  @override
  String itemsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mục',
      one: '1 mục',
      zero: 'Không có mục',
    );
    return '$_temp0';
  }

  @override
  String helloUser(String name) {
    return 'Xin chào, $name!';
  }
}
