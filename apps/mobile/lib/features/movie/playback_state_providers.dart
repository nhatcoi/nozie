import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nozie_mobile/core/services/shared_prefs_provider.dart';
import 'package:nozie_mobile/features/movie/playback_state_service.dart';

final playbackStateServiceProvider = Provider<PlaybackStateService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PlaybackStateService(prefs);
});

