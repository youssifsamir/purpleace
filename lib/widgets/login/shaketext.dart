import 'package:flutter/material.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';

class ShakeMeText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final Curve curve;
  final double shakeOffset;
  final int shakeCount;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final bool autoShake;

  const ShakeMeText({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 700),
    this.curve = Curves.elasticIn,
    this.shakeOffset = 10,
    this.shakeCount = 3,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
    this.autoShake = true,
  });

  @override
  State<ShakeMeText> createState() => _ShakeMeTextState();
}

class _ShakeMeTextState extends State<ShakeMeText> {
  final shakeKey = GlobalKey<ShakeWidgetState>();

  @override
  void initState() {
    super.initState();
    if (widget.autoShake) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        shakeKey.currentState?.shake();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShakeMe(
      key: shakeKey,
      shakeCount: widget.shakeCount,
      shakeOffset: widget.shakeOffset,
      shakeDuration: widget.duration,
      child: Container(
        padding:
            widget.padding ??
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.red.withOpacity(0.1),
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        ),
        child: Text(
          widget.text,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style:
              widget.style ??
              const TextStyle(
                fontSize: 18,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
