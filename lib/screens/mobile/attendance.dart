// ignore_for_file: use_key_in_widget_constructors

// packages
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:purpleace/widgets/attendance/datetime.dart';

// widgets
import '/widgets/attendance/welcometxt.dart';

class AttendanceScreen extends StatelessWidget {
  static final routeName = './mobile/attendance.dart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WelcomeTxtWidget(),
            SizedBox(height: 50.h),
            LiveTimeDateWidget(),
          ],
        ),
      ),
    );
  }
}
