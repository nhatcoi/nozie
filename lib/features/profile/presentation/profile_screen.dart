import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_fe/core/app_export.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
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
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      AppColors.getText(context),
                      BlendMode.srcIn,
                    ),
                  ),


                )
              ],
            ),

          ],
        ),
      ),
    );
  }
}
