import 'package:flutter/material.dart';
import 'package:nozie_mobile/core/utils/image_constant.dart';
import 'package:nozie_mobile/core/widgets/skeleton.dart';

class NetworkOrAssetImage extends StatelessWidget {
  const NetworkOrAssetImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorWidget,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? errorWidget;

  bool get _isNetworkUrl {
    return imageUrl.startsWith('http://') || 
           imageUrl.startsWith('https://');
  }

  int? _cacheWidth(BuildContext context) {
    final w = width;
    if (w == null || !w.isFinite) return null;
    return (w * MediaQuery.devicePixelRatioOf(context)).round();
  }

  @override
  Widget build(BuildContext context) {
    if (_isNetworkUrl) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          if (errorWidget != null) return errorWidget!;
          return Image.asset(
            ImageConstant.imgImageNotFound,
            width: width,
            height: height,
            fit: BoxFit.cover,
          );
        },
        // Decode no larger than needed: full-size posters in a carousel are wasted memory.
        cacheWidth: _cacheWidth(context),
        // A shaped skeleton (not a spinner) keeps the layout stable until the image arrives.
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Skeleton(width: width, height: height ?? 120, radius: 0);
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          if (errorWidget != null) return errorWidget!;
          return Image.asset(
            ImageConstant.imgImageNotFound,
            width: width,
            height: height,
            fit: BoxFit.cover,
          );
        },
      );
    }
  }
}

