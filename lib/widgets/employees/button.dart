// ignore_for_file: deprecated_member_use, must_be_immutable

// packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class EditButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed; // <-- add this
  final double? fontSize; // <-- add this
  final double width, height;
  final Icon icon;
  bool? collapsed;

  EditButton({
    super.key,
    this.collapsed = false,
    this.onPressed,
    this.fontSize,
    required this.icon,
    required this.text,
    required this.height,
    required this.width,
  });

  @override
  State<EditButton> createState() => _EditButton();
}

class _EditButton extends State<EditButton> with TickerProviderStateMixin {
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
        return SizedBox(
          height: widget.height,
          child: Neumorphic(
            style: NeumorphicStyle(
              depth:
                  widget.text == 'تسجيل الخروج' ||
                          widget.text == 'Logout' ||
                          widget.text == ''
                      ? -6
                      : 6,
              intensity: 0.8,
              lightSource: LightSource.topLeft,
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(30.r),
              ),
              // : const Color.fromARGB(185, 200, 230, 201),
            ),
            child: ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    widget.text == 'Logout' || widget.text == ''
                        ? Colors.white
                        : colorScheme.primary.withOpacity(0.75),
                padding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                ), // to make height consistent
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.icon,
                  if (widget.collapsed == null || widget.collapsed == false)
                    SizedBox(width: 2.w),
                  if (widget.collapsed == null || widget.collapsed == false)
                    Text(
                      widget.text,
                      style: TextStyle(
                        fontSize: widget.fontSize ?? 3.5.sp,
                        // color: Colors.black.withOpacity(0.15),
                        color:
                            widget.text == 'Logout' || widget.text == ''
                                ? Colors.black54
                                : Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
