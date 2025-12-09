// packages
// ignore_for_file: deprecated_member_use

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// providers
// import '/providers/auth.dart';

class DateGradientColumn extends StatelessWidget {
  const DateGradientColumn({super.key});

  @override
  Widget build(BuildContext context) {
    final String today = DateFormat('EEEE, MMMM d').format(DateTime.now());
    // final username = context.watch<AuthProvider>().user!.name;
    final username = 'Youssif Samir';

    // final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          today,
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            fontSize: 4.sp,
            color: Colors.black,
            fontFamily: 'RalewayMid',
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          textScaler: TextScaler.noScaling,

          "Hello, $username",
          style: TextStyle(
            fontSize: (10.sp).clamp(12, 30),
            color: Colors.black,
            fontFamily: 'RalewayBold',
          ),
        ),
        ShaderMask(
          shaderCallback:
              (bounds) => LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.purple,
                  Colors.deepPurpleAccent,
                  Colors.pinkAccent,
                ],
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
          child: Text(
            textScaler: TextScaler.noScaling,

            "Let's start! What will we be working on today?",
            style: TextStyle(
              fontSize: 8.sp,
              fontFamily: 'Poppins',
              color: Colors.white, // still needed for ShaderMask
              // shadows: [
              //   Shadow(
              //     offset: const Offset(10, 10),
              //     blurRadius: 5,
              //     color: Colors.black.withOpacity(0.05), // shadow color
              //   ),
              // ],
            ),
          ),
        ),
      ],
    );
  }
}
