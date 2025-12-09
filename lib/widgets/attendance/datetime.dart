// packages
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveTimeDateWidget extends StatefulWidget {
  const LiveTimeDateWidget({super.key});

  @override
  State<LiveTimeDateWidget> createState() => _LiveTimeDateWidgetState();
}

class _LiveTimeDateWidgetState extends State<LiveTimeDateWidget> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('hh:mm a').format(_now); // 08:45 AM
    final day = DateFormat('EEEE').format(_now); // Monday
    final monthDate = DateFormat('MMM d').format(_now); // Dec 3

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// ⏰ TIME
        Text(
          time,
          style: TextStyle(fontSize: 24.sp, fontFamily: 'PoppinsSemiBold'),
        ),

        SizedBox(height: 5.h),

        /// 📅 DAY | DATE
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'Poppins',
                color: Colors.black45,
              ),
            ),

            SizedBox(width: 5.w),

            /// Divider
            Container(height: 18, width: 1.5, color: Colors.grey),

            SizedBox(width: 5.w),

            Text(
              monthDate,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'Poppins',
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
