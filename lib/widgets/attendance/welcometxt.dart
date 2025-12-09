// packages
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeTxtWidget extends StatelessWidget {
  const WelcomeTxtWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome',
              style: TextStyle(
                fontFamily: 'PoppinsBold',
                color: colorScheme.primary,
                fontSize: 24.sp,
              ),
            ),
            Text(
              ' Youssif Samir',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black87,
                fontSize: 24.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        Text(
          'Video Editor Intern',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black45,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}
