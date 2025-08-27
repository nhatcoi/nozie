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
    return {
      'action': context.l10n.action,
      'adventure': context.l10n.adventure,
      'animation': context.l10n.animation,
      'comedy': context.l10n.comedy,
      'crime': context.l10n.crime,
      'documentary': context.l10n.documentary,
      'drama': context.l10n.drama,
      'family': context.l10n.family,
      'fantasy': context.l10n.fantasy,
      'horror': context.l10n.horror,
      'mystery': context.l10n.mystery,
      'romance': context.l10n.romance,
      'sci_fi': context.l10n.sciFi,
      'thriller': context.l10n.thriller,
      'war': context.l10n.war,
      'western': context.l10n.western,
    };
  }
}

class Genders {
  static Map<String, String> getOptions(BuildContext context) {
    return {
      'male': context.l10n.iAmMale,
      'female': context.l10n.iAmFemale,
      'other': context.l10n.ratherNotToSay,
    };
  }
}

class Ages {
  static Map<String, String> getOptions(BuildContext context) {
    return {
      '14-17': context.l10n.age14to17,
      '18-24': context.l10n.age18to24,
      '25-29': context.l10n.age25to29,
      '30-34': context.l10n.age30to34,
      '35-39': context.l10n.age35to39,
      '40-44': context.l10n.age40to44,
      '45-49': context.l10n.age45to49,
      '50': context.l10n.age50plus,
    };
  }
}


