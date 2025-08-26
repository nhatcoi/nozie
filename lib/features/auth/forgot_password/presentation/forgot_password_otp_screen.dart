import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_fe/features/auth/forgot_password/presentation/providers/otp_vm.dart';
import 'package:movie_fe/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';

class ForgotPasswordOtpScreen extends ConsumerStatefulWidget {
  const ForgotPasswordOtpScreen({
    super.key,
    required this.email,
    this.length = 4,
    this.initialSeconds = 60,
  });

  final String email;
  final int length;
  final int initialSeconds;

  @override
  ConsumerState<ForgotPasswordOtpScreen> createState() =>
      _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState
    extends ConsumerState<ForgotPasswordOtpScreen> {
  late final List<TextEditingController> _c;
  late final List<FocusNode> _n;

  @override
  void initState() {
    super.initState();
    _c = List.generate(widget.length, (_) => TextEditingController());
    _n = List.generate(widget.length, (_) => FocusNode());

    for (final node in _n) {
      node.addListener(() {
        if (mounted) setState(() {});
      });
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _n.first.requestFocus(),
    );
  }

  @override
  void dispose() {
    for (final e in _c) {
      e.dispose();
    }
    for (final e in _n) {
      e.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctx = Theme.of(context);
    final theme = Theme.of(context).textTheme;
    final t = AppLocalizations.of(context)!;

    final args = (
      email: widget.email,
      length: widget.length,
      initialSeconds: widget.initialSeconds,
    );
    final provider = otpVmProvider(args);

    ref.listen<OtpVmState>(provider, (prev, next) {
      for (var i = 0; i < widget.length; i++) {
        final txt = next.digits[i];
        if (_c[i].text != txt) {
          _c[i].value = TextEditingValue(
            text: txt,
            selection: TextSelection.collapsed(offset: txt.length),
          );
        }
      }
    });

    final vm = ref.watch(provider);
    final ctrl = ref.read(provider.notifier);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 16, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.otpTitle, style: theme.displaySmall),

                  const SizedBox(height: 12),

                  Text(t.otpDes, style: theme.titleLarge),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 16,
                    children: List.generate(widget.length, (i) {
                      return Expanded(
                        child: Focus(
                          onKeyEvent: (_, e) {
                            if (e is KeyDownEvent &&
                                e.logicalKey == LogicalKeyboardKey.backspace) {
                              if (_c[i].text.isEmpty && i > 0) {
                                _n[i - 1].requestFocus();
                                _c[i - 1].clear();
                                ctrl.setDigit(i - 1, '');
                              }
                            }
                            return KeyEventResult.ignored;
                          },
                          child: Row(
                            children: [
                              TextField(
                                controller: _c[i],
                                focusNode: _n[i],
                                textAlign: TextAlign.center,
                                style: theme.headlineLarge,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                maxLength: 1,
                                maxLengthEnforcement: MaxLengthEnforcement.none,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],

                                decoration: InputDecoration(
                                  counterText: "",
                                  filled: true,
                                  fillColor: _n[i].hasFocus
                                      ? AppColors.trOrange
                                      : isDark
                                      ? AppColors.dark2
                                      : AppColors.greyscale50,
                                  contentPadding: EdgeInsets.zero,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: isDark
                                          ? AppColors.dark4
                                          : AppColors.greyscale200,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: AppColors.primary500,
                                      width: 2,
                                    ),
                                  ),
                                ),

                                onChanged: (v) {
                                  if (v.length > 1) {
                                    // rải chuỗi dán vào các ô
                                    final s = v.replaceAll(RegExp(r'\D'), '');
                                    // cập nhật VM 1 phát
                                    ctrl.paste(s);
                                    // cập nhật UI ngay
                                    for (var k = 0; k < widget.length; k++) {
                                      final ch = k < s.length ? s[k] : '';
                                      _c[k].value = TextEditingValue(
                                        text: ch,
                                        selection:
                                            const TextSelection.collapsed(
                                              offset: 1,
                                            ),
                                      );
                                    }
                                    // focus vào ô tiếp theo hợp lý
                                    final next = (s.length >= widget.length)
                                        ? widget.length - 1
                                        : s.length;
                                    _n[next].requestFocus();
                                    return;
                                  }
                                  ctrl.setDigit(i, v);
                                  if (v.isNotEmpty && i < widget.length - 1) {
                                    _n[i + 1].requestFocus();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),

              Column(),
            ],
          ),
        ),
      ),
    );
  }
}
