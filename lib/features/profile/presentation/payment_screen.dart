import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_fe/core/app_export.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Payment Methods',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ContentWrappers.page(
              context,
              child: Column(
                children: const [
                  _PaymentMethodRow(
                    iconAsset: ImageConstant.paypalIcon,
                    title: 'PayPal',
                  ),
                  _Divider(),
                  _PaymentMethodRow(
                    iconAsset: ImageConstant.googlePayIcon,
                    title: 'Google Pay',
                  ),
                  _Divider(),
                  _PaymentMethodRow(
                    iconAsset: ImageConstant.appleIcon,
                    title: 'Apple Pay',
                  ),
                  _Divider(),
                  _PaymentMethodRow(
                    iconAsset: ImageConstant.visaIcon,
                    title: '•••• •••• •••• 5567',
                  ),
                  _Divider(),
                  _PaymentMethodRow(
                    iconAsset: ImageConstant.americanExpressIcon,
                    title: '•••• •••• •••• 8456',
                  ),
                  _Divider(),
                  _PaymentMethodRow(
                    iconAsset: ImageConstant.mastercardIcon,
                    title: '•••• •••• •••• 7839',
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.getText(context).withOpacity(0.08),
              ),
              Padding(
                padding: ResponsivePadding.content(context).copyWith(top: 26, bottom: 26),
                child: PrimaryButton(
                  text: 'Add New',
                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                  textColor: Colors.white,
                  onPressed: () {},
                  hasShadow: true,
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodRow extends StatelessWidget {
  final String iconAsset;
  final String title;

  const _PaymentMethodRow({
    required this.iconAsset,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = AppColors.getText(context);
    return Row(
      children: [
        SvgPicture.asset(
          iconAsset,
          width: 40,
          height: 40,
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
        Text(
          'Connected',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.primary500,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(
        height: 1,
        color: AppColors.getText(context).withOpacity(0.08),
      ),
    );
  }
}


