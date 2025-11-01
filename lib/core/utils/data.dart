import '../widgets/inputs/dropdown.dart';
import 'package:flutter/material.dart';
import '../extension/context_extensions.dart';
import 'image_constant.dart';

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

class Languages {
  static const List<DropdownItem> suggested = [
    DropdownItem(value: 'en_us', label: 'English (US)'),
    DropdownItem(value: 'vi_vn', label: 'Tiếng Việt'),
  ];

  static const List<DropdownItem> others = [
    DropdownItem(value: 'ko_kr', label: '한국어 (Korean)'),
    DropdownItem(value: 'ja_jp', label: '日本語 (Japanese)'),
    DropdownItem(value: 'fr_fr', label: 'Français (French)'),
    DropdownItem(value: 'de_de', label: 'Deutsch (German)'),
    DropdownItem(value: 'zh_cn', label: '中文 (Simplified Chinese)'),
    DropdownItem(value: 'zh_tw', label: '中文 (Traditional Chinese)'),
    DropdownItem(value: 'es_es', label: 'Español (Spanish)'),
    DropdownItem(value: 'pt_br', label: 'Português (Brazilian)'),
    DropdownItem(value: 'id_id', label: 'Bahasa Indonesia'),
    DropdownItem(value: 'th_th', label: 'ภาษาไทย (Thai)'),
    DropdownItem(value: 'ms_my', label: 'Bahasa Melayu'),
    DropdownItem(value: 'hi_in', label: 'हिन्दी (Hindi)'),
  ];
}

class HelpCenterData {
  static const List<FaqItem> faqs = [
    FaqItem(
      category: 'General',
      question: 'What is Nozie?',
      answer:
          'Nozie is your personal hub for discovering, reading, and listening to stories. Browse curated recommendations, organise your library, and stay synced across devices.',
    ),
    FaqItem(
      category: 'Service',
      question: 'How to purchase an Ebook?',
      answer:
          'Open the book detail page, tap the “Buy” button, choose a payment method, then confirm. Purchased titles instantly appear in your Library tab.',
    ),
    FaqItem(
      category: 'Account',
      question: 'How to add a payment method?',
      answer:
          'Head to Profile > Payment Methods, choose “Add New”, enter your card or wallet details, and save. You can manage or remove methods anytime from the same screen.',
    ),
    FaqItem(
      category: 'Account',
      question: 'How do I reset my password?',
      answer:
          'Go to Login > Forgot Password, enter your email, and follow the verification steps. You can set a new password once you confirm the OTP sent to your inbox.',
    ),
    FaqItem(
      category: 'Ebook',
      question: 'How can I download ebooks for offline reading?',
      answer:
          'Open any purchased title, tap the download icon, and choose the device storage location. Downloads are available offline from your Library tab.',
    ),
    FaqItem(
      category: 'Account',
      question: 'How do I change the app language?',
      answer:
          'Navigate to Profile > Language to select your preferred language. Your choice syncs instantly across all sections of the app.',
    ),
    FaqItem(
      category: 'Service',
      question: 'Why is my audiobook not playing?',
      answer:
          'Ensure your device volume is up and you have a stable connection. If the issue persists, try clearing cache from Profile > Help Center and restart the app.',
    ),
    FaqItem(
      category: 'Service',
      question: 'How to manage notifications?',
      answer:
          'Go to Profile > Notification Settings to enable or disable alerts for recommendations, purchases, promotions, and more.',
    ),
    FaqItem(
      category: 'Service',
      question: 'How do I request a refund?',
      answer:
          'Contact support via Help Center > Contact Us, provide your order ID, and our team will review within 24 hours.',
    ),
    FaqItem(
      category: 'Account',
      question: 'How can I delete my account?',
      answer:
          'Open Settings > Security > Delete Account. Follow the instructions to confirm your identity and complete the deletion process.',
    ),
    FaqItem(
      category: 'General',
      question: 'How do I sync reading progress across devices?',
      answer:
          'Make sure you are signed in on all devices. Progress syncs automatically when the device is online; pull to refresh in Library to force a sync.',
    ),
    FaqItem(
      category: 'General',
      question: 'What formats does Nozie support?',
      answer:
          'Nozie supports EPUB, PDF, and MP3 audiobook files. Uploaded personal files are converted automatically for best playback.',
    ),
    FaqItem(
      category: 'Ebook',
      question: "Why can't I purchase an ebook?",
      answer:
          'Verify that you have a valid payment method added and a stable internet connection. If the issue persists, try signing out and back in before attempting the purchase again.',
    ),
    FaqItem(
      category: 'Ebook',
      question: "Why can't I download an ebook?",
      answer:
          'Ensure the title is purchased and you have sufficient storage space. Downloads require Wi-Fi unless you enable cellular downloads in Preferences.',
    ),
    FaqItem(
      category: 'Account',
      question: "Why can't I add a payment method?",
      answer:
          'Check that your card details are correct and supported in your region. Some prepaid cards and virtual wallets may be restricted by your bank or country.',
    ),
    FaqItem(
      category: 'Movies',
      question: "Why can't I close an account on Erabook?",
      answer:
          'If you linked your Nozie account with Erabook, unlink the integration under Profile > Connected Services first. Afterwards, submit the closure request from the Erabook dashboard.',
    ),
  ];

  static const List<ContactOption> contacts = [
    ContactOption(
      title: 'Customer Service',
      subtitle: 'support@nozie.app',
      iconAsset: ImageConstant.contactSupportIcon,
    ),
    ContactOption(
      title: 'WhatsApp',
      subtitle: '+1 800 123 4567',
      iconAsset: ImageConstant.contactChatIcon,
    ),
    ContactOption(
      title: 'Website',
      subtitle: 'www.nozie.app/support',
      iconAsset: ImageConstant.contactWebsiteIcon,
    ),
    ContactOption(
      title: 'Facebook',
      subtitle: '@NozieOfficial',
      iconAsset: ImageConstant.contactFacebookIcon,
    ),
    ContactOption(
      title: 'Twitter',
      subtitle: '@NozieApp',
      iconAsset: ImageConstant.contactTwitterIcon,
    ),
    ContactOption(
      title: 'Instagram',
      subtitle: '@nozie.app',
      iconAsset: ImageConstant.contactInstagramIcon,
    ),
  ];
}

class FaqItem {
  final String category;
  final String question;
  final String answer;

  const FaqItem({
    required this.category,
    required this.question,
    required this.answer,
  });
}

class ContactOption {
  final String title;
  final String subtitle;
  final String iconAsset;

  const ContactOption({
    required this.title,
    required this.subtitle,
    required this.iconAsset,
  });
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
