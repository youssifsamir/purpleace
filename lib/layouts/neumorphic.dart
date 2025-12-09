// ignore_for_file: deprecated_member_use

// packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class NeumorphicGradientCircle extends StatelessWidget {
  final bool top;
  final Widget child;
  final bool isPressed;

  const NeumorphicGradientCircle({
    super.key,
    required this.top,
    required this.child,
    this.isPressed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      drawSurfaceAboveChild: true,
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat, // ✅ better for shadows
        boxShape: const NeumorphicBoxShape.circle(),
        depth: isPressed ? -20 : 20, // ✅ real shadow depth
        intensity: 0.9,
        color: const Color(0xFF1E1E1E), // ✅ MUST NOT be transparent
        shadowDarkColor: Colors.black.withOpacity(0.4),
        shadowLightColor: Colors.white.withOpacity(0.2),
        lightSource: top ? LightSource.topLeft : LightSource.bottomRight,
      ),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 492.r,
        child: Stack(
          children: [
            Positioned(
              top: -50,
              right: 300,
              child: SizedBox(
                width: 800,
                child: Image.asset('./assets/imgs/3.png'),
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.15), // adjust opacity here
              ),
            ),
          ],
        ),
      ),
    );
  }
}
