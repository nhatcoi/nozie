import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nozie_mobile/core/network/error_messages.dart';
import 'package:nozie_mobile/core/widgets/state_views.dart';

/// One place that turns an [AsyncValue] into loading, error (with retry), empty or content, so every
/// screen handles the four states the same way instead of re-implementing `.when`.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.onRetry,
    this.isEmpty,
    this.empty,
    this.compactError = false,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;

  /// Defaults to a centred spinner; pass a skeleton for a better first paint.
  final Widget? loading;
  final VoidCallback? onRetry;

  /// When it returns true for the loaded data, [empty] is shown instead of [data].
  final bool Function(T data)? isEmpty;
  final Widget? empty;

  /// For small inline sections: hide errors quietly instead of taking the whole area.
  final bool compactError;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: (d) {
        if (isEmpty != null && isEmpty!(d)) return empty ?? const SizedBox.shrink();
        return data(d);
      },
      loading: () => loading ?? const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, _) {
        if (compactError) return const SizedBox.shrink();
        return ErrorState(message: errorMessage(e), onRetry: onRetry);
      },
    );
  }
}
