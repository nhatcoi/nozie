import 'package:intl/intl.dart';
import 'package:nozie_mobile/core/models/movie_item.dart';
import 'package:nozie_mobile/i18n/translations.g.dart';

/// Price display. The catalog stores USD; the Vietnamese UI shows a rounded VND equivalent.
abstract final class PriceUtils {
  /// Numeric price from a `{usd, vnd}` map or a plain number (USD preferred).
  static double? getPriceValue(dynamic price) {
    if (price == null) return null;
    if (price is num) return price.toDouble();
    if (price is Map) {
      final usd = price['usd'];
      if (usd is num) return usd.toDouble();
      final vnd = price['vnd'];
      if (vnd is num) return vnd.toDouble();
    }
    return null;
  }

  /// `$2.99` or `69.000 ₫` (VND is rounded to the nearest 1.000 so it never shows odd amounts).
  /// Returns an empty string when there is no price in the requested currency.
  static String formatAmount({double? usd, num? vnd, required bool vietnamese}) {
    if (vietnamese) {
      if (vnd == null) return '';
      final rounded = (vnd / 1000).round() * 1000;
      return '${NumberFormat.decimalPattern('vi').format(rounded)} ₫';
    }
    if (usd == null) return '';
    return NumberFormat.currency(locale: 'en', symbol: r'$', decimalDigits: 2).format(usd);
  }

  static bool get _vietnamese => LocaleSettings.currentLocale == AppLocale.vi;

  static bool isFree(MovieItem movie) {
    final data = movie.priceData;
    if (data != null) {
      final amount = data[_vietnamese ? 'vnd' : 'usd'] as num?;
      return amount == null || amount == 0;
    }
    return movie.price == null || movie.price == 0;
  }

  /// "Free" for free movies, otherwise the formatted price.
  static String formatPrice(MovieItem movie) {
    if (isFree(movie)) return t.common.free;
    final data = movie.priceData;
    return formatAmount(
      usd: (data?['usd'] as num?)?.toDouble() ?? movie.price,
      vnd: data?['vnd'] as num?,
      vietnamese: _vietnamese,
    );
  }

  /// Label for the purchase button ("Buy $2.99" / "Mua 69.000 ₫").
  static String formatPriceForButton(MovieItem movie) => t.movie.hero.buy(price: formatPrice(movie));
}
