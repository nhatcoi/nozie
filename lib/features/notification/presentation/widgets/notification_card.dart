import 'package:flutter/material.dart';
import 'package:movie_fe/core/enums/status_type.dart';
import 'package:movie_fe/core/theme/app_colors.dart';
import 'package:movie_fe/core/utils/data/date_util.dart';
import 'package:movie_fe/features/notification/presentation/widgets/notification_icon.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.type,
    required this.title,
    required this.time,
    required this.description,
  });

  final StatusType type;
  final String title;
  final DateTime time;
  final String description;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    final isNew = false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(
          spacing: 12,
          children: [
            Flexible(child: NotificationIcon(type: type)),
            Expanded(
              flex: 3,
              child: Column(
                spacing: 6,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(title, style: t.textTheme.headlineSmall),
                  Row(
                    spacing: 8,
                    children: [
                      Text(DateUtil.formatRelativeDate(time,context)),
                      Text("|"),
                      Text(DateFormat('hh:mm a').format(DateTime.now())),
                    ],
                  ),
                ],
              ),
            ),
            isNew
                ? Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: AppColors.primary500,
                      ),
                      child: Center(
                        child: Text(
                          "New",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
        Text(
          description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: t.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
