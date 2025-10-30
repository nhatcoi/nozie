import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_fe/core/app_export.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_fe/routes/app_router.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(ImageConstant.imgAvatar),
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'John Doe',
                      style: TextStyle(
                        color: AppColors.getText(context),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '@gmail.com'
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {

                  },
                  icon: SvgPicture.asset(
                    ImageConstant.editIcon,
                    width: 14,
                    height: 14,
                    colorFilter: ColorFilter.mode(
                      AppColors.getText(context),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),

            _Divider(),
            
            _SettingItem(
              lightBackgroundColor: const Color(0xFFE7F8EF),
              iconAsset: ImageConstant.walletColorIcon,
              title: 'Payment Methods',
              onTap: () => context.push(AppRouter.paymentMethods),
            ),

            _Divider(),

            _SettingItem(
              lightBackgroundColor: const Color(0xFFE9F0FF),
              iconAsset: ImageConstant.profileColorIcon,
              title: 'Personal Info',
              onTap: () {},
            ),
            _SettingItem(
              lightBackgroundColor: const Color(0xFFFFEFEF),
              iconAsset: ImageConstant.ringColorIcon,
              title: 'Notification',
              onTap: () {},
            ),
            _SettingItem(
              lightBackgroundColor: const Color(0xFFF3EEFF),
              iconAsset: ImageConstant.settingColorIcon,
              title: 'Preferences',
              onTap: () {},
            ),
            _SettingItem(
              lightBackgroundColor: const Color(0xFFEAF7F1),
              iconAsset: ImageConstant.guardIcon,
              title: 'Security',
              onTap: () {},
            ),
            _SettingItem(
              lightBackgroundColor: const Color(0xFFFFF4E6),
              iconAsset: ImageConstant.categoryColorIcon,
              title: 'Language',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'English (US)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.getText(context).withOpacity(0.7),
                        ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    ImageConstant.arrowRightIcon,
                    width: 14,
                    height: 14,
                    colorFilter: ColorFilter.mode(
                      AppColors.getText(context).withOpacity(0.5),
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
              onTap: () {},
            ),
            Consumer(
              builder: (context, ref, _) {
                final mode = ref.watch(themeModeProvider);
                final isDark = mode == ThemeMode.dark;
                return _SettingItem(
                  lightBackgroundColor: const Color(0xFFE9F0FF),
                  iconAsset: ImageConstant.eyeColorIcon,
                  title: 'Dark Mode',
                  trailing: Switch.adaptive(
                    value: isDark,
                    onChanged: (val) {
                      final notifier = ref.read(themeModeProvider.notifier);
                      notifier.set(val ? ThemeMode.dark : ThemeMode.light);
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            _SettingItem(
              lightBackgroundColor: const Color(0xFFE7F8EF),
              iconAsset: ImageConstant.documentColorIcon,
              title: 'Help Center',
              onTap: () {},
            ),
            _SettingItem(
              lightBackgroundColor: const Color(0xFFFFF4E6),
              iconAsset: ImageConstant.infoIcon,
              title: 'About NoZie',
              onTap: () {},
            ),

            const SizedBox(height: 8),

            _LogoutItem(onTap: () {}),

          ],
        ),
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final String iconAsset;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color lightBackgroundColor;

  const _SettingItem({
    required this.iconAsset,
    required this.title,
    required this.lightBackgroundColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = AppColors.getText(context);
    final bg = _bgForTheme(context, lightBackgroundColor);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: bg,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                iconAsset,
                width: 18,
                height: 18,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            trailing ?? SvgPicture.asset(
              ImageConstant.arrowRightIcon,
              width: 14,
              height: 14,
              colorFilter: ColorFilter.mode(
                textColor.withOpacity(0.5),
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(
        height: 1,
        color: AppColors.getText(context).withOpacity(0.08),
      ),
    );
  }
}

class _LogoutItem extends StatelessWidget {
  final VoidCallback? onTap;
  const _LogoutItem({this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _bgForTheme(context, const Color(0xFFFFE9EB)),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              ImageConstant.logoutIcon,
              width: 18,
              height: 18,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Logout',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFFFF4D4D),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

// Util: generate dark-mode friendly background from a light pastel
Color _bgForTheme(BuildContext context, Color lightColor) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  if (!isDark) return lightColor;
  final hsl = HSLColor.fromColor(lightColor);
  // Reduce lightness and saturation for better dark backgrounds
  final darkHsl = hsl.withSaturation((hsl.saturation * 0.6).clamp(0.0, 1.0))
      .withLightness((hsl.lightness * 0.25).clamp(0.0, 1.0));
  return darkHsl.toColor().withOpacity(0.6);
}
