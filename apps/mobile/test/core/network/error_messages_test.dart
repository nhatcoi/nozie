import 'package:flutter_test/flutter_test.dart';
import 'package:nozie_mobile/core/network/api_exception.dart';
import 'package:nozie_mobile/core/network/error_messages.dart';
import 'package:nozie_mobile/i18n/translations.g.dart';

ApiException _e(String code, {int? status}) => ApiException(code: code, message: 'server text', statusCode: status);

void main() {
  setUp(() => LocaleSettings.setLocale(AppLocale.en));

  test('server error codes become friendly text, never the raw server message', () {
    expect(errorMessage(_e('INVALID_CREDENTIALS')), 'Incorrect email or password.');
    expect(errorMessage(_e('EMAIL_TAKEN')), 'This email is already registered.');
    expect(errorMessage(_e('PURCHASE_REQUIRED')), 'Purchase this movie to watch it.');
    expect(errorMessage(_e('MOVIE_NOT_FOUND')), errorMessage(_e('NOT_FOUND')));
    expect(errorMessage(_e('INVALID_CREDENTIALS')), isNot(contains('server text')));
  });

  test('connectivity problems get their own messages', () {
    expect(errorMessage(_e('NETWORK')), contains('connection'));
    expect(errorMessage(_e('TIMEOUT')), contains('too long'));
  });

  test('unknown 5xx is a server problem, anything else is generic, non-API errors never leak', () {
    expect(errorMessage(_e('SOMETHING_NEW', status: 503)), contains('our side'));
    expect(errorMessage(_e('SOMETHING_NEW', status: 400)), 'Something went wrong. Please try again.');
    expect(errorMessage(StateError('Bad state: secret detail')), 'Something went wrong. Please try again.');
  });

  test('messages follow the app language', () {
    LocaleSettings.setLocale(AppLocale.vi);
    expect(errorMessage(_e('INVALID_CREDENTIALS')), 'Email hoặc mật khẩu không đúng.');
  });
}
