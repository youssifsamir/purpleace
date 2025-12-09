// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

enum CustomNeumorphicShape { convex, concave, flat }

enum NeumorphicLightSource { topLeft, topRight, bottomLeft, bottomRight }

class NeumorphicContainer extends StatefulWidget {
  final Widget? child;
  final double width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color color;
  final Gradient? gradient;
  final BorderRadiusGeometry borderRadius;
  final CustomNeumorphicShape shape; // convex = raised, concave = pressed
  final NeumorphicLightSource lightSource;
  final double depth; // how offset the shadow is
  final double blur; // shadow blur
  final double intensity; // 0..1 - shadow strength multiplier
  final bool showInnerShadow;
  final Duration duration;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enableTilt;
  final double tiltAngle; // small rotation for 3d feel, in degrees

  const NeumorphicContainer({
    super.key,
    this.child,
    this.width = double.infinity,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.color = const Color(0xFFF2F2F3),
    this.gradient,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.shape = CustomNeumorphicShape.convex,
    this.lightSource = NeumorphicLightSource.topLeft,
    this.depth = 6.0,
    this.blur = 12.0,
    this.intensity = 0.8,
    this.showInnerShadow = false,
    this.duration = const Duration(milliseconds: 220),
    this.onTap,
    this.onLongPress,
    this.enableTilt = false,
    this.tiltAngle = 4.0,
  });

  @override
  State<NeumorphicContainer> createState() => _NeumorphicContainerState();
}

class _NeumorphicContainerState extends State<NeumorphicContainer> {
  bool _pressed = false;

  // derive shadow colors from base color
  Color _darker(Color c, [double amount = 0.12]) {
    final f = 1 - amount;
    return Color.fromARGB(
      c.alpha,
      (c.red * f).round(),
      (c.green * f).round(),
      (c.blue * f).round(),
    );
  }

  Color _lighter(Color c, [double amount = 0.12]) {
    int blend(int a, int b) => (a + ((255 - a) * b)).round();
    final amt = amount;
    return Color.fromARGB(
      c.alpha,
      blend(c.red, (amt * 255).round()),
      blend(c.green, (amt * 255).round()),
      blend(c.blue, (amt * 255).round()),
    );
  }

  // light offset depending on source
  Offset _lightOffset(double depth) {
    switch (widget.lightSource) {
      case NeumorphicLightSource.topLeft:
        return Offset(-depth, -depth);
      case NeumorphicLightSource.topRight:
        return Offset(depth, -depth);
      case NeumorphicLightSource.bottomLeft:
        return Offset(-depth, depth);
      case NeumorphicLightSource.bottomRight:
        return Offset(depth, depth);
    }
  }

  @override
  Widget build(BuildContext context) {
    // transform tilt
    final tilt = widget.enableTilt && !_pressed ? widget.tiltAngle : 0.0;
    final tiltRad = tilt * (3.14159265 / 180.0);

    // compute shadow colors
    final base = widget.color;
    final dark = _darker(base, 0.18 * widget.intensity);
    final light = _lighter(base, 0.85 * widget.intensity);

    // offsets
    final depth = _pressed ? widget.depth / 2 : widget.depth;
    final shadowOffset = _lightOffset(depth);
    final opposite = Offset(-shadowOffset.dx, -shadowOffset.dy);

    // choose order depending on shape
    final outerShadows =
        widget.shape == CustomNeumorphicShape.concave
            ? [
              // highlight first then shadow to mimic pressed
              BoxShadow(
                color: light.withOpacity(0.95),
                offset: opposite,
                blurRadius: widget.blur,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: dark.withOpacity(0.65),
                offset: shadowOffset,
                blurRadius: widget.blur,
                spreadRadius: 0,
              ),
            ]
            : [
              // raised: dark shadow then highlight
              BoxShadow(
                color: dark.withOpacity(0.30),
                offset: shadowOffset,
                blurRadius: widget.blur,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: light.withOpacity(0.95),
                offset: opposite,
                blurRadius: widget.blur,
                spreadRadius: 0,
              ),
            ];

    // inner shadow optional (drawn via Stack)
    // final innerShadow =
    //     widget.showInnerShadow
    //         ? [
    //           // subtle inner dark
    //           BoxShadow(
    //             color: Colors.black.withOpacity(0.08 * widget.intensity),
    //             offset: shadowOffset,
    //             blurRadius: widget.blur / 1.8,
    //             spreadRadius: 0,
    //           ),
    //         ]
    //         : null;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
      },
      onTapUp: (_) async {
        await Future.delayed(const Duration(milliseconds: 80));
        setState(() => _pressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      onLongPress: widget.onLongPress,
      child: AnimatedContainer(
        duration: widget.duration,
        margin: widget.margin,
        width: widget.width == double.infinity ? double.infinity : widget.width,
        height: widget.height,
        padding: widget.padding,
        transform:
            widget.enableTilt
                ? (Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(tiltRad * (shadowOffset.dy.sign))
                  ..rotateY(-tiltRad * (shadowOffset.dx.sign)))
                : null,
        decoration: BoxDecoration(
          color: widget.gradient == null ? widget.color : null,
          gradient: widget.gradient,
          borderRadius: widget.borderRadius,
          boxShadow:
              _pressed
                  ? [
                    BoxShadow(
                      color: dark.withOpacity(0.65 * widget.intensity),
                      offset: opposite,
                      blurRadius: widget.blur / 1.6,
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: light.withOpacity(0.95 * widget.intensity),
                      offset: shadowOffset,
                      blurRadius: widget.blur / 1.6,
                      spreadRadius: 0,
                    ),
                  ]
                  : outerShadows,
        ),
        child: Stack(
          children: [
            if (widget.showInnerShadow)
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: widget.borderRadius,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            0.08 * widget.intensity,
                          ),
                          offset: shadowOffset,
                          blurRadius: widget.blur / 1.8,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Center(child: widget.child),
          ],
        ),
      ),
    );
  }
}
