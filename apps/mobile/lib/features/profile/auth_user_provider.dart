import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nozie_mobile/features/profile/user_profile.dart';
import 'package:nozie_mobile/features/profile/profile_notifier.dart';

final authUserProvider = Provider<AsyncValue<UserProfile>>((ref) {
  return ref.watch(profileNotifierProvider);
});


