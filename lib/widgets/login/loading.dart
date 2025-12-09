// ignore_for_file: deprecated_member_use, unreachable_switch_default

// packages
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// A generic, customizable loading indicator using the loading_animation_widget package.
class LoadingIndicatorWidget extends StatelessWidget {
  /// Whether to show or hide the loading indicator.
  final bool isLoading;

  /// The color of the animation.
  final Color color;

  /// The size of the loading animation.
  final double size, textheight;

  /// The type of loading animation to display.
  final LoadingAnimationType type;

  /// Optional background color for overlay effect.
  final Color? backgroundColor;

  /// Optional text to display below the animation.
  final String? loadingText;

  const LoadingIndicatorWidget({
    super.key,
    required this.isLoading,
    this.color = Colors.blue,
    this.size = 75,
    this.textheight = 25,
    this.type = LoadingAnimationType.discreteCircle,
    this.backgroundColor,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    Widget animation;
    final colorScheme = Theme.of(context).colorScheme;

    switch (type) {
      case LoadingAnimationType.discreteCircle:
        animation = LoadingAnimationWidget.discreteCircle(
          color: colorScheme.primary,
          secondRingColor: Colors.purple,
          thirdRingColor: colorScheme.surfaceTint,
          size: size,
        );
        break;
      case LoadingAnimationType.threeArchedCircle:
        animation = LoadingAnimationWidget.threeArchedCircle(
          color: color,
          size: size,
        );
        break;
      case LoadingAnimationType.flickr:
        animation = LoadingAnimationWidget.flickr(
          leftDotColor: color,
          rightDotColor: color.withOpacity(0.7),
          size: size,
        );
        break;
      case LoadingAnimationType.hexagonDots:
        animation = LoadingAnimationWidget.hexagonDots(
          color: color,
          size: size,
        );
        break;
      case LoadingAnimationType.staggeredDotsWave:
        animation = LoadingAnimationWidget.staggeredDotsWave(
          color: color,
          size: size,
        );
        break;
      default:
        animation = LoadingAnimationWidget.discreteCircle(
          color: color,
          size: size,
        );
    }

    return Container(
      color: backgroundColor ?? Colors.transparent,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          animation,
          if (loadingText != null) ...[
            SizedBox(height: textheight),
            Text(
              loadingText!,
              style: TextStyle(
                fontFamily: 'RalewayReg',
                fontSize: 4.sp,
                color: Colors.black87,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Enum to represent different types of loading animations.
enum LoadingAnimationType {
  discreteCircle,
  threeArchedCircle,
  flickr,
  hexagonDots,
  staggeredDotsWave,
}
