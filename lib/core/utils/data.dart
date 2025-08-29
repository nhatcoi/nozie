import '../widgets/dropdown.dart';
import 'package:flutter/material.dart';
import '../extension/context_extensions.dart';

class Countries {
  static const List<DropdownItem> list = [
    DropdownItem(value: 'vn', label: 'Vietnam'),
    DropdownItem(value: 'us', label: 'United States'),
    DropdownItem(value: 'uk', label: 'United Kingdom'),
    DropdownItem(value: 'ca', label: 'Canada'),
    DropdownItem(value: 'au', label: 'Australia'),
    DropdownItem(value: 'de', label: 'Germany'),
    DropdownItem(value: 'fr', label: 'France'),
    DropdownItem(value: 'jp', label: 'Japan'),
    DropdownItem(value: 'kr', label: 'South Korea'),
    DropdownItem(value: 'cn', label: 'China'),
    DropdownItem(value: 'in', label: 'India'),
    DropdownItem(value: 'br', label: 'Brazil'),
    DropdownItem(value: 'mx', label: 'Mexico'),
    DropdownItem(value: 'sg', label: 'Singapore'),
    DropdownItem(value: 'my', label: 'Malaysia'),
    DropdownItem(value: 'th', label: 'Thailand'),
    DropdownItem(value: 'ph', label: 'Philippines'),
    DropdownItem(value: 'id', label: 'Indonesia'),
    DropdownItem(value: 'tw', label: 'Taiwan'),
    DropdownItem(value: 'hk', label: 'Hong Kong'),
  ];
}

class Genres {
  static Map<String, String> getOptions(BuildContext context) {
    final t = context.i18n;
    return {
      'action': t.auth.register.steps.genres.list.action,
      'adventure': t.auth.register.steps.genres.list.adventure,
      'animation': t.auth.register.steps.genres.list.animation,
      'comedy': t.auth.register.steps.genres.list.comedy,
      'crime': t.auth.register.steps.genres.list.crime,
      'documentary': t.auth.register.steps.genres.list.documentary,
      'drama': t.auth.register.steps.genres.list.drama,
      'family': t.auth.register.steps.genres.list.family,
      'fantasy': t.auth.register.steps.genres.list.fantasy,
      'horror': t.auth.register.steps.genres.list.horror,
      'mystery': t.auth.register.steps.genres.list.mystery,
      'romance': t.auth.register.steps.genres.list.romance,
      'sci_fi': t.auth.register.steps.genres.list.sciFi,
      'thriller': t.auth.register.steps.genres.list.thriller,
      'war': t.auth.register.steps.genres.list.war,
      'western': t.auth.register.steps.genres.list.western,
    };
  }
}

class Genders {
  static Map<String, String> getOptions(BuildContext context) {
    final t = context.i18n;
    return {
      'male': t.auth.register.steps.gender.choices.iAmMale,
      'female': t.auth.register.steps.gender.choices.iAmFemale,
      'other': t.auth.register.steps.gender.choices.ratherNotToSay,
    };
  }
}

class Ages {
  static Map<String, String> getOptions(BuildContext context) {
    final t = context.i18n;
    return {
      '14-17': t.auth.register.steps.age.ranges.age14to17,
      '18-24': t.auth.register.steps.age.ranges.age18to24,
      '25-29': t.auth.register.steps.age.ranges.age25to29,
      '30-34': t.auth.register.steps.age.ranges.age30to34,
      '35-39': t.auth.register.steps.age.ranges.age35to39,
      '40-44': t.auth.register.steps.age.ranges.age40to44,
      '45-49': t.auth.register.steps.age.ranges.age45to49,
      '50': t.auth.register.steps.age.ranges.age50plus,
    };
  }
}


