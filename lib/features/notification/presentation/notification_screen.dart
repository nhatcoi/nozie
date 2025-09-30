import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:movie_fe/core/app_export.dart';
import 'package:movie_fe/core/enums/status_type.dart';
import 'package:movie_fe/features/notification/presentation/widgets/notification_card.dart';
import 'package:movie_fe/features/notification/presentation/widgets/notification_icon.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.i18n;
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;
    final data = "";
    final isHaveNoti = data.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.notification.title,style: theme.textTheme.headlineLarge),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ContentWrapper(
        child: isHaveNoti ? Padding(
          padding: EdgeInsets.symmetric(vertical: 140),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(isDark ? ImageConstant.notificationFrameDark : ImageConstant.notificationFrame),
                Gap(60),
                Text(t.common.empty,style: theme.textTheme.headlineLarge),
                Gap(12),
                Text(t.notification.empty,style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w400,
                )),
              ],
            ),
          ),
        ) : SingleChildScrollView(
          child: Column(
            spacing: 24,
            children: [
                NotificationCard(type: StatusType.update, title: 'hihi', time: DateTime.now(), description: 'haha',)
            ],
          ),
        ),
      ),
    );
  }
}
