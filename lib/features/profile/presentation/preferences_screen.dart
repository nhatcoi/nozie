import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movie_fe/core/app_export.dart';
import 'package:movie_fe/features/profile/models/preferences.dart';
import 'package:movie_fe/features/profile/notifiers/preferences_notifier.dart';

class PreferencesScreen extends ConsumerWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferencesState = ref.watch(preferencesNotifierProvider);
    final prefs = preferencesState.value ?? Preferences.defaults;
    final notifier = ref.read(preferencesNotifierProvider.notifier);

    if (preferencesState.isLoading && preferencesState.value == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    void showClearCacheSheet() {
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.getSurface(context),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (sheetContext) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Clear Cache',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.getText(context),
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Currently stored: ${_cacheLabel(prefs.cacheSizeMb)}. Removing cache will delete temporary files but keep your downloads and preferences.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.getTextSecondary(context),
                      ),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: 'Clear Cache',
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    notifier.updateFields(cacheSizeMb: 0);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cache cleared'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  hasShadow: true,
                ),
                const SizedBox(height: 12),
                SecondaryButton(
                  text: 'Cancel',
                  onPressed: () => Navigator.of(sheetContext).pop(),
                ),
              ],
            ),
          );
        },
      );
    }

    void showOptionsSheet({
      required String title,
      required List<String> options,
      required String selected,
      required ValueChanged<String> onSelect,
    }) {
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.getSurface(context),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (sheetContext) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.getText(context),
                      ),
                ),
                const SizedBox(height: 16),
                ...options.map(
                  (option) => RadioListTile<String>(
                    value: option,
                    groupValue: selected,
                    onChanged: (value) {
                      if (value == null) return;
                      onSelect(value);
                      Navigator.of(sheetContext).pop();
                    },
                    activeColor: AppColors.primary500,
                    title: Text(option),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Preferences',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          const _SectionLabel(title: 'General'),
          _ToggleTile(
            title: 'Download Over Wi-Fi Only',
            value: prefs.wifiOnlyDownloads,
            onChanged: (value) => notifier.updateFields(wifiOnlyDownloads: value),
          ),
          _ActionTile(
            title: 'Clear Cache',
            value: _cacheLabel(prefs.cacheSizeMb),
            onPressed: showClearCacheSheet,
          ),
          const SizedBox(height: 24),
          const _SectionLabel(title: 'Playback'),
          _ToggleTile(
            title: 'Auto Play Next Episode',
            value: prefs.autoPlayNextEpisode,
            onChanged: (value) => notifier.updateFields(autoPlayNextEpisode: value),
          ),
          _ToggleTile(
            title: 'Continue Watching from Last Position',
            value: prefs.continueWatching,
            onChanged: (value) => notifier.updateFields(continueWatching: value),
          ),
          _ToggleTile(
            title: 'Subtitles',
            value: prefs.subtitlesEnabled,
            onChanged: (value) => notifier.updateFields(subtitlesEnabled: value),
          ),
          const SizedBox(height: 24),
          const _SectionLabel(title: 'Video'),
          _ActionTile(
            title: 'Video Quality',
            value: prefs.videoQuality,
            onPressed: () => showOptionsSheet(
              title: 'Video Quality',
              options: const ['Auto', 'HD', 'Full HD'],
              selected: prefs.videoQuality,
              onSelect: (value) => notifier.updateFields(videoQuality: value),
            ),
          ),
          _ToggleTile(
            title: 'Auto Rotate Screen',
            value: prefs.autoRotateScreen,
            onChanged: (value) => notifier.updateFields(autoRotateScreen: value),
          ),
          const SizedBox(height: 24),
          const _SectionLabel(title: 'Audio'),
          _ActionTile(
            title: 'Audio Language / Quality',
            value: prefs.audioPreference,
            onPressed: () => showOptionsSheet(
              title: 'Audio Language / Quality',
              options: const [
                'System Default',
                'English • High Quality',
                'Original • Standard',
              ],
              selected: prefs.audioPreference,
              onSelect: (value) => notifier.updateFields(audioPreference: value),
            ),
          ),
          _ToggleTile(
            title: 'Automatically Download Audio',
            value: prefs.autoDownloadAudio,
            onChanged: (value) => notifier.updateFields(autoDownloadAudio: value),
          ),
        ],
      ),
    );
  }
}

String _cacheLabel(double value) {
  if (value <= 0) return '0 MB stored';
  return '${value.toStringAsFixed(0)} MB stored';
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.getText(context),
            ),
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.getText(context),
            ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary500,
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.title,
    this.value,
    required this.onPressed,
  });

  final String title;
  final String? value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final subtitle = value;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.getText(context),
            ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.getTextSecondary(context),
                  ),
            )
          : null,
      trailing: Icon(
        Icons.chevron_right,
        color: AppColors.getTextSecondary(context),
      ),
      onTap: onPressed,
    );
  }
}


