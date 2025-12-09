// ignore_for_file: deprecated_member_use

// packages
import 'package:glow_container/glow_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class PrettySlideGlowingButton extends StatefulWidget {
  final bool isActive;
  final String text, username;
  final VoidCallback? onPressed; // <-- add this
  final double width, height;

  const PrettySlideGlowingButton({
    super.key,
    this.onPressed,
    required this.text,
    required this.username,
    required this.isActive,
    required this.height,
    required this.width,
  });

  @override
  State<PrettySlideGlowingButton> createState() =>
      _PrettySlideGlowingButtonState();
}

class _PrettySlideGlowingButtonState extends State<PrettySlideGlowingButton>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnim;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _glowAnim = CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOutCubic,
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  @override
  void didUpdateWidget(covariant PrettySlideGlowingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive) {
      _glowController.forward();
      _slideController.forward();
    } else {
      _glowController.reverse();
      _slideController.reverse();
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (context, child) {
        return GestureDetector(
          onTap: widget.onPressed,
          child: GlowContainer(
            showAnimatedBorder: true,
            containerOptions: ContainerOptions(
              borderRadius: 50.r,
              borderSide: const BorderSide(style: BorderStyle.none),
            ),
            glowRadius: 10.r,
            gradientColors: [
              widget.isActive
                  ? colorScheme.surfaceTint.withOpacity(0)
                  : Colors.white,
            ],
            rotationDuration: const Duration(seconds: 1),
            glowLocation: GlowLocation.both,
            child: Neumorphic(
              style: NeumorphicStyle(
                depth: widget.isActive ? 6 : -6,
                intensity: 0.8,
                lightSource: LightSource.topLeft,
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(30.r),
                ),
                color:
                    widget.isActive
                        ? colorScheme.primary.withOpacity(0.45)
                        : const Color.fromARGB(184, 221, 200, 230),
              ),
              child: Container(
                width: widget.width,
                height: widget.height,
                alignment: Alignment.center,
                child: AnimatedBuilder(
                  animation: _slideController,
                  builder: (context, child) {
                    final slide = Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(-0.6, 0),
                    ).animate(
                      CurvedAnimation(
                        parent: _slideController,
                        curve: Curves.easeInOutCubic,
                      ),
                    );

                    final fadeOut = Tween<double>(begin: 1, end: 0).animate(
                      CurvedAnimation(
                        parent: _slideController,
                        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
                      ),
                    );

                    final fadeIn = Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(
                        parent: _slideController,
                        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
                      ),
                    );

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Text slides out
                        SlideTransition(
                          position: slide,
                          child: FadeTransition(
                            opacity: fadeOut,
                            child: Text(
                              widget.text,
                              style: TextStyle(
                                fontSize: 4.sp,
                                color:
                                    widget.isActive
                                        ? Colors.white
                                        : Colors.black.withOpacity(0.15),
                                fontFamily:
                                    widget.isActive
                                        ? 'RalewayBold'
                                        : 'RalewayMid',
                              ),
                            ),
                          ),
                        ),
                        // Icon slides in
                        FadeTransition(
                          opacity: fadeIn,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: FittedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Welcome ${widget.username}',
                                    softWrap: true,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      color:
                                          widget.isActive
                                              ? Colors.white
                                              : Colors.black.withOpacity(0.15),
                                      fontFamily:
                                          widget.isActive
                                              ? 'RalewayReg'
                                              : 'RalewayReg',
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 5.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
