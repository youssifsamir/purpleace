// packages
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showTopSnackbar(BuildContext context, String message, int color) {
  final overlay = Overlay.of(context);

  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) {
      return _TopXPSnackbarWidget(
        color: color,
        message: message,
        onDismissed: () => overlayEntry.remove(),
      );
    },
  );

  overlay.insert(overlayEntry);
}

class _TopXPSnackbarWidget extends StatefulWidget {
  final int color;
  final String message;
  final VoidCallback onDismissed;

  const _TopXPSnackbarWidget({
    required this.color,
    required this.message,
    required this.onDismissed,
  });

  @override
  State<_TopXPSnackbarWidget> createState() => _TopXPSnackbarWidgetState();
}

class _TopXPSnackbarWidgetState extends State<_TopXPSnackbarWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Auto dismiss after x seconds
    Future.delayed(Duration(milliseconds: 3500), () async {
      if (mounted) {
        await _dismiss();
      }
    });
  }

  Future<void> _dismiss() async {
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Positioned(
      top: 30.h, // move a bit from top if you want
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _animation,
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta != null && details.primaryDelta! < -10) {
              _dismiss();
            }
          },
          child: Center(
            // center horizontally
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(16.r),
              color:
                  widget.color == 0
                      ? Colors.black
                      : widget.color == 1
                      ? Colors.green
                      : Colors.red,
              child: Container(
                width: screenWidth * 0.5, // 90% of screen width
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Text(
                  widget.color == 1
                      ? "✅  ${widget.message}"
                      : widget.color == 2
                      ? "❌  ${widget.message}"
                      : widget.message,
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PoppinsMid',
                    fontSize: 4.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
