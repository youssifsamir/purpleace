// packages
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// components
import '/widgets/login/shaketext.dart';

class ShakeErrorWidget extends StatelessWidget {
  final String error;
  final double offset;
  final int count, milliseconds;
  const ShakeErrorWidget({
    super.key,
    required this.offset,
    required this.milliseconds,
    required this.count,
    this.error = 'An error has occured, try again or contact superadmin',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: ShakeMeText(
        text:
            error == "The supplied auth credential is malformed or has expired."
                ? "Invalid password"
                : error,
        //  ?? 'An error has occured, try again or contact superadmin',
        style: TextStyle(
          fontSize: 4.sp,
          fontFamily: 'RalewayReg',
          color: colorScheme.error,
        ),
        duration: Duration(milliseconds: milliseconds),
        shakeCount: count,
        shakeOffset: offset,
        backgroundColor: Colors.white,
      ),
    );
  }
}
