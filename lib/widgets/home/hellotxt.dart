// ignore_for_file: deprecated_member_use

// packages
import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

// providers
// import '/providers/auth.dart';
// import '/providers/branch.dart';

// widgets
// import '/widgets/branchmang/addnew.dart';

class DateGradientColumn extends StatelessWidget {
  final String username;
  const DateGradientColumn({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, d MMMM', 'en').format(DateTime.now());

    // final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

    // final branchprovider = context.watch<BranchProvider>();
    // final authprovider = context.watch<AuthProvider>();

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
          "Hello, $username 👋",
          style: TextStyle(
            fontSize: (10.sp).clamp(12, 30),
            color: Colors.black87,
            fontFamily: 'RalewayBold',
          ),
        ),

        ShaderMask(
          shaderCallback:
              (bounds) => LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.deepPurple,
                  Colors.purpleAccent,
                  Colors.lightBlue,
                ],
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
          child: Text(
            textScaler: TextScaler.noScaling,
            "Which card would you like to start playing?",
            style: TextStyle(
              fontSize: 8.sp,
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
