import 'package:flutter_test/flutter_test.dart';
import 'package:nozie_mobile/core/models/movie_item.dart';
import 'package:nozie_mobile/core/utils/price_utils.dart';
import 'package:nozie_mobile/i18n/translations.g.dart';

MovieItem _movie({double? usd, num? vnd}) => MovieItem(
      id: 'm',
      title: 'M',
      imageUrl: '',
      price: usd,
      priceData: usd == null ? null : {'usd': usd, 'vnd': vnd ?? (usd * 23000).round()},
    );

void main() {
  test('USD is shown with a symbol and two decimals', () {
    expect(PriceUtils.formatAmount(usd: 2.99, vietnamese: false), r'$2.99');
    expect(PriceUtils.formatAmount(usd: 1234.5, vietnamese: false), r'$1,234.50');
  });

  test('VND is rounded to the nearest thousand and grouped with dots', () {
    expect(PriceUtils.formatAmount(vnd: 68770, vietnamese: true), '69.000 ₫');
    expect(PriceUtils.formatAmount(vnd: 1500000, vietnamese: true), '1.500.000 ₫');
  });

  test('a missing price in the requested currency renders nothing', () {
    expect(PriceUtils.formatAmount(vietnamese: true), '');
    expect(PriceUtils.formatAmount(vietnamese: false), '');
  });

  test('free movies say so in the current language', () {
    LocaleSettings.setLocale(AppLocale.en);
    expect(PriceUtils.isFree(_movie(usd: 0)), isTrue);
    expect(PriceUtils.formatPrice(_movie(usd: 0)), 'Free');
    LocaleSettings.setLocale(AppLocale.vi);
    expect(PriceUtils.formatPrice(_movie(usd: 0)), 'Miễn phí');
  });

  test('paid movies follow the language and drive the buy button', () {
    LocaleSettings.setLocale(AppLocale.en);
    expect(PriceUtils.formatPrice(_movie(usd: 2.99)), r'$2.99');
    expect(PriceUtils.formatPriceForButton(_movie(usd: 2.99)), r'Buy $2.99');
    LocaleSettings.setLocale(AppLocale.vi);
    expect(PriceUtils.formatPrice(_movie(usd: 2.99)), '69.000 ₫');
    expect(PriceUtils.formatPriceForButton(_movie(usd: 2.99)), 'Mua 69.000 ₫');
  });
}
