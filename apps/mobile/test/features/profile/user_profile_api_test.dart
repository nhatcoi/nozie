import 'package:flutter_test/flutter_test.dart';
import 'package:nozie_mobile/features/profile/user_profile_api.dart';

void main() {
  test('maps API user JSON and converts ISO date to dd/MM/yyyy', () {
    final p = UserProfileApi.fromApi({
      'id': 'u1',
      'fullName': 'Noah',
      'email': 'n@example.com',
      'dateOfBirth': '1990-03-07',
    });
    expect(p.id, 'u1');
    expect(p.dateOfBirth, '07/03/1990');
    expect(p.username, '');
  });

  test('patch body sends only non-empty fields with ISO date', () {
    final p = UserProfileApi.fromApi({'id': 'u1', 'fullName': 'Noah', 'email': 'n@e.com'});
    final patch = p.copyWith(dateOfBirth: '07/03/1990', country: 'vn').toApiPatch();
    expect(patch['dateOfBirth'], '1990-03-07');
    expect(patch['country'], 'vn');
    expect(patch.containsKey('phone'), isFalse);
  });

  test('bad dates are ignored instead of sent', () {
    expect(displayToIsoDate('not a date'), isNull);
    expect(isoToDisplayDate(null), '');
  });

  test('server-relative avatar paths become absolute URLs on the API origin', () {
    final p = UserProfileApi.fromApi({'id': 'u1', 'avatarUrl': '/api/v1/users/u1/avatar?v=123'});
    expect(p.avatarUrl, startsWith('http'));
    expect(p.avatarUrl, endsWith('/api/v1/users/u1/avatar?v=123'));
    expect(UserProfileApi.fromApi({'id': 'u1'}).avatarUrl, '');
  });
}
