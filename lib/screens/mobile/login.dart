// ignore_for_file: use_build_context_synchronously, deprecated_member_use, unused_local_variable

// packages
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:purpleace/screens/mobile/attendance.dart';

// providers
import '/providers/sidebar.dart';

// screens
// import 'navigator2.dart';

// widgets
import '/widgets/login/error.dart';
import '/widgets/login/button.dart';
// import '/widgets/login/loading.dart';
import '/widgets/login/textfield.dart';

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({super.key});

  static final routeName = './mobile/login.dart';

  @override
  Widget build(BuildContext context) {
    bool success = true, isLoading = false;
    final sidebarprovider = context.watch<SidebarProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          //BODY_COLUMN
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //CLIENT_LOGO
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25.r)),
                child: SizedBox(
                  height: 125.h,
                  child: Image.asset(
                    './assets/imgs/logo.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              SizedBox(height: 50.h),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                reverseDuration: const Duration(milliseconds: 600),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final fadeIn = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  );
                  final fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  );

                  // When the child changes, fade out the old one first, then fade in the new one
                  return FadeTransition(opacity: fadeIn, child: child);
                },
                child: _buildEnglishTextRow(colorScheme),
              ),

              SizedBox(height: 7.h),

              //SIGN IN TXT
              Text(
                'Sign in to your account',
                style: TextStyle(fontFamily: 'RalewayReg', fontSize: 18.sp),
              ),
              SizedBox(height: 50.h),

              //USERNAME TEXTFIELD
              TextFieldNeumorphic(
                width: 335.w,
                height: 50.h,
                type: 'username',
                fontsize: 15.sp,
                onChanged: (value) => null,
              ),

              SizedBox(height: 35.h),

              //PASSWORD TEXTFIELD
              TextFieldNeumorphic(
                width: 335.w,
                height: 40.h,
                type: 'password',
                fontsize: 15.sp,

                // onChanged: (val) => provider.setPassword(val),
                onChanged: (value) => null,
              ),

              SizedBox(height: 50.h),
              success == false
                  ? ShakeErrorWidget(
                    // error: provider.message!,
                    error: 'Error',
                    offset: 2,
                    count: 4,
                    milliseconds: 350,
                  )
                  : SizedBox(),

              //SIGN IN BUTTON & ERROR DISPLAY
              Container(
                width: 300.w,
                height: 50.h,
                color: Colors.transparent,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                  ) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child:
                  // provider.isLoading
                  // isLoading
                  //     ? LoadingIndicatorWidget(
                  //       size: 60.h,
                  //       textheight: 25.h,
                  //       key: const ValueKey('Loading...'),
                  //       // isLoading: provider.isLoading,
                  //       isLoading: isLoading,
                  //       loadingText: 'Signing in...',
                  //       backgroundColor: Colors.transparent,
                  //       type: LoadingAnimationType.discreteCircle,
                  //     )
                  //     :
                  PrettySlideGlowingButton(
                    text: 'Sign in',
                    width: 300.w,
                    height: 50.h,
                    key: const ValueKey('button'),
                    // isActive: provider.allFilled,
                    // username: provider.username,
                    isActive: true,
                    username: 'youssifsamir',
                    onPressed:
                        () => Navigator.pushNamed(
                          context,
                          AttendanceScreen.routeName,
                        ),
                    // provider.isLoading
                    //     ? null
                    //     : () async {
                    //       await provider.login();
                    //       if (provider.success == true) {
                    //         Session.instance.token =
                    //             provider.user!.token;
                    //         Session.instance.branchId =
                    //             provider.user!.branchId;
                    //         final categoryprovider =
                    //             Provider.of<MenuCategoryProvider>(
                    //               context,
                    //               listen: false,
                    //             ).refresh();
                    //         sidebarprovider.setAllowedRoles(
                    //           provider.user!.role,
                    //         );
                    //         await branchprovider.fetchBranches(
                    //           token: provider.user!.token,
                    //         );
                    //         Navigator.pushNamed(
                    //           context,
                    //           HomeScreen.routeName,
                    //         );
                    //         provider.setLoading(false);
                    //       } else {
                    //         provider.resetFilled();
                    //       }
                    //     },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildEnglishTextRow(ColorScheme colorScheme) {
  return Row(
    key: const ValueKey('english_text'),
    mainAxisAlignment: MainAxisAlignment.center,

    children: [
      NeumorphicText(
        'Hello ',
        style: NeumorphicStyle(
          depth: 8,
          intensity: 1,
          surfaceIntensity: 0.2,
          color: Colors.black87,
          lightSource: LightSource.topLeft,
        ),
        textStyle: NeumorphicTextStyle(
          fontSize: 27.sp,
          fontFamily: 'RalewayBold',
          fontWeight: FontWeight.bold,
        ),
      ),
      NeumorphicText(
        ' Purple Ace Agency',
        style: NeumorphicStyle(
          depth: 8,
          intensity: 1,
          surfaceIntensity: 0.2,
          color: colorScheme.primary,
          lightSource: LightSource.topLeft,
        ),
        textStyle: NeumorphicTextStyle(
          fontSize: 27.sp,
          fontFamily: 'RalewayReg',
        ),
      ),
    ],
  );
}
