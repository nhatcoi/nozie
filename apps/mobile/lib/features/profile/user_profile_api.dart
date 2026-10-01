import 'package:nozie_mobile/core/config/env.dart';
import 'package:nozie_mobile/features/profile/user_profile.dart';

/// Conversions between the API's user JSON and the app's [UserProfile].
/// The API uses ISO dates (`yyyy-MM-dd`); the UI shows `dd/MM/yyyy`.
extension UserProfileApi on UserProfile {
  static UserProfile fromApi(Map<String, dynamic> json) {
    return UserProfile(
      id: (json['id'] ?? '').toString(),
      fullName: (json['fullName'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      dateOfBirth: isoToDisplayDate(json['dateOfBirth'] as String?),
      country: (json['country'] ?? '').toString(),
      avatarUrl: _absoluteUrl(json['avatarUrl'] as String?),
    );
  }

  /// Body for `PATCH /users/me`. Only non-empty fields are sent.
  Map<String, dynamic> toApiPatch() {
    final dob = displayToIsoDate(dateOfBirth);
    return {
      if (fullName.trim().isNotEmpty) 'fullName': fullName.trim(),
      if (username.trim().isNotEmpty) 'username': username.trim(),
      if (phone.trim().isNotEmpty) 'phone': phone.trim(),
      if (dob != null) 'dateOfBirth': dob,
      if (country.trim().isNotEmpty) 'country': country.trim(),
    };
  }
}

/// The API returns server-relative avatar paths; image widgets need absolute URLs.
String _absoluteUrl(String? path) {
  if (path == null || path.isEmpty) return '';
  return path.startsWith('http') ? path : '${Env.apiOrigin}$path';
}

String isoToDisplayDate(String? iso) {
  if (iso == null || iso.length != 10) return '';
  final p = iso.split('-');
  return p.length == 3 ? '${p[2]}/${p[1]}/${p[0]}' : '';
}

String? displayToIsoDate(String display) {
  final p = display.trim().split('/');
  if (p.length != 3) return null;
  final d = int.tryParse(p[0]);
  final m = int.tryParse(p[1]);
  final y = int.tryParse(p[2]);
  if (d == null || m == null || y == null) return null;
  String two(int n) => n.toString().padLeft(2, '0');
  return '${y.toString().padLeft(4, '0')}-${two(m)}-${two(d)}';
}
