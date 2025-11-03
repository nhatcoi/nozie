import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '../../../../core/app_export.dart';
import '../../../../core/models/movie.dart';
import '../../../profile/models/payment_method.dart';
import '../../../profile/notifiers/payment_notifier.dart';
import '../../services/payment_service.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = AppColors.getText(context);
    final secondaryText = AppColors.getTextSecondary(context);
    final paymentState = ref.watch(paymentNotifierProvider);
    final paymentMethods = paymentState.value ?? const <PaymentMethod>[];
    final defaultMethod = paymentMethods.firstWhere(
      (method) => method.isDefault,
      orElse: () => paymentMethods.isNotEmpty 
          ? paymentMethods.first 
          : const PaymentMethod(
              id: '',
              label: '',
              brand: '',
              last4: '',
              isDefault: false,
            ),
    );

    final price = widget.movie.priceValue ?? 0.0;
    final isFree = price == 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 24,
                children: [
                  // Movie Summary
                  _buildMovieSummary(context, theme, textColor),
                  const Gap(24),
                  // Price Details
                  _buildPriceDetails(context, theme, textColor, secondaryText, price),
                  const Gap(24),
                  // Payment Method Selection
                  if (!isFree) ...[
                    _buildSectionTitle('Payment Method', theme, textColor),
                    const Gap(12),
                    paymentState.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, _) => Center(
                        child: Text(
                          'Failed to load payment methods',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                      data: (_) => Column(
                        spacing: 12,
                        children: [
                          for (final method in paymentMethods)
                            _buildPaymentMethodCard(
                              context,
                              theme,
                              textColor,
                              method,
                              method.id == defaultMethod.id,
                              () {
                                ref.read(paymentNotifierProvider.notifier).setDefault(method.id);
                              },
                            ),
                          const Gap(8),
                          _buildAddPaymentMethodButton(context, theme),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.getSurface(context),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: secondaryText,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            isFree ? 'Free' : '\$${price.toStringAsFixed(2)}',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 200,
                        child: PrimaryButton(
                          text: _isProcessing ? 'Processing...' : (isFree ? 'Confirm' : 'Pay Now'),
                          onPressed: _isProcessing ? null : () => _processPayment(context, defaultMethod),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieSummary(BuildContext context, ThemeData theme, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        spacing: 16,
        children: [
          Container(
            width: 80,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(widget.movie.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  widget.movie.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.movie.rating != null) ...[
                  Row(
                    spacing: 8,
                    children: [
                      SvgPicture.asset(
                        ImageConstant.groupIcon,
                        width: 16,
                        height: 16,
                        colorFilter: const ColorFilter.mode(AppColors.primary500, BlendMode.srcIn),
                      ),
                      Text(
                        widget.movie.rating!.toStringAsFixed(1),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDetails(BuildContext context, ThemeData theme, Color textColor, Color secondaryText, double price) {
    if (price == 0.0) {
      return _buildSectionTitle('Price Details', theme, textColor);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Price Details', theme, textColor),
        const Gap(12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.getSurface(context),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            spacing: 12,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Price',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: secondaryText,
                    ),
                  ),
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Divider(height: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme, Color textColor) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context,
    ThemeData theme,
    Color textColor,
    PaymentMethod method,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.getSurface(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary500 : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          spacing: 16,
          children: [
            SvgPicture.asset(
              _iconForMethod(method),
              width: 40,
              height: 40,
            ),
            Expanded(
              child: Text(
                method.label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Radio<String>(
              value: method.id,
              groupValue: isSelected ? method.id : '',
              onChanged: (_) => onTap(),
              activeColor: AppColors.primary500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPaymentMethodButton(BuildContext context, ThemeData theme) {
    return InkWell(
      onTap: () {
        // TODO: Navigate to add payment method
        Navigator.of(context).pushNamed('/payment-methods');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary500,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            const Icon(Icons.add, color: AppColors.primary500),
            Text(
              'Add Payment Method',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.primary500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _iconForMethod(PaymentMethod method) {
    switch (method.brand.toLowerCase()) {
      case 'google pay':
        return ImageConstant.googlePayIcon;
      case 'apple pay':
        return ImageConstant.appleIcon;
      case 'visa':
        return ImageConstant.visaIcon;
      case 'american express':
        return ImageConstant.americanExpressIcon;
      case 'mastercard':
        return ImageConstant.mastercardIcon;
      case 'paypal':
      default:
        return ImageConstant.paypalIcon;
    }
  }

  Future<void> _processPayment(BuildContext context, PaymentMethod method) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final paymentService = ref.read(paymentServiceProvider);
      final success = await paymentService.processPurchase(
        movie: widget.movie,
        paymentMethodId: method.id,
      );

      if (context.mounted) {
        if (success) {
          Navigator.of(context).pop(true); // Return success
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment successful! 🎬'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment failed. Please try again.'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
}

