// ignore_for_file: deprecated_member_use

// packages
import 'package:flutter/gestures.dart';
// import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:purpleace/providers/auth.dart';

// services
// import '/services/session.dart';

// providers
// import '/providers/auth.dart';
// import '/providers/branch.dart';
// import '/providers/sidebar.dart';
// import '/providers/language.dart';
// import '/providers/employee.dart';

// widgets
import '/widgets/home/divider.dart';
import '/widgets/home/hellotxt.dart';
import '/widgets/home/cardbuilder.dart';
import '/widgets/home/3DContainer.dart';

class DesktopHomeScreen extends StatelessWidget {
  const DesktopHomeScreen({super.key});

  static const routeName = './desktop/home.dart';

  @override
  Widget build(BuildContext context) {
    // final branchprovider = context.watch<BranchProvider>();
    // final employeeprovider = context.watch<EmployeeProvider>();
    // final siderbarprovider = context.watch<SidebarProvider>();
    final authprovider = context.watch<AuthProvider>();

    return Padding(
      padding: EdgeInsets.only(top: 150.h, left: 10.w, right: 10.w),

      child: Column(
        children: [
          SizedBox(
            width: 325.w,
            height: 150.h,
            child: DateGradientColumn(
              username:
                  "${authprovider.currentUser!.personalInfo.firstName} ${authprovider.currentUser!.personalInfo.lastName}",
            ),
          ),
          DividerWidget(customthinckness: 1.5),
          Expanded(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(
                scrollbars: false,
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                },
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: 100.h),
                  child: BranchCardsBuilder(
                    isArabic: false,
                    // onTap: (branchId) {
                    //   Session.instance.branchId = branchId;
                    //   employeeprovider.selectBranch(branchId);
                    //   branchprovider.setSelectedBranch(branchId);
                    //   siderbarprovider.select(2);
                    // },
                    color: Colors.white10,
                    cardWidth: 250,
                    imgWidth: 350 / 1.25,
                    cardHeight: 45,
                    horizontalSpacing: 40.w,
                    tiltAngle: 0,
                    depth: 10,
                    intensity: 0.1,
                    lightSource: NeumorphicLightSource.topLeft,
                    enableTilt: false,
                    hoveredgradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      // colors: [Colors.red, Colors.lightGreen],
                      colors: [
                        Colors.lightBlue,
                        Colors.purple,
                        Colors.deepPurple,
                      ],
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.white, Colors.white],
                    ),

                    // onTap: (id) => print("Tapped branch $id"),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
