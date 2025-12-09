// ignore_for_file: use_build_context_synchronously

// packages
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

// screens
import '/screens/desktop/navigator.dart';

// providers
import '/providers/auth.dart';
import '/providers/sidebar.dart';

// layouts
import '/layouts/blobs.dart';
import '/layouts/neumorphic.dart';

// widgets
import '/widgets/login/error.dart';
import '/widgets/login/button.dart';
import '/widgets/login/loading.dart';
import '/widgets/login/textfield.dart';

// components
import '/widgets/components/topsnackbar.dart';

class LoginScreens extends StatelessWidget {
  LoginScreens({super.key});

  static final routeName = './login2.dart';

  final _forgotPasswordFormKey = GlobalKey<FormState>();

  final isCheckedNotifier = ValueNotifier(false);

  void showAddEmployeeDialog({
    required BuildContext context,
    required AuthProvider provider,
  }) {
    final parentContext = context;
    final usernameOrEmailController = TextEditingController();

    showDialog(
      context: parentContext,
      barrierDismissible: true,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: Text(
                "Reset Password",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 6.sp),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: _forgotPasswordFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _dialogField(
                            "Username or Email",
                            usernameOrEmailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a First Name';
                              }
                              return null;
                            },
                          ),
                          Text(
                            "Enter your email or username, and we will send you a link to reset your password.",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 3.5.sp,
                              color: Colors.black38,
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 4.sp,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),

                // ✅ SAVE BUTTON
                provider.isLoading2
                    ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: CircularProgressIndicator(
                        color: Colors.purple,
                        strokeWidth: 1.w,
                      ),
                    )
                    : ElevatedButton(
                      onPressed: () async {
                        setDialogState(() {});
                        final result = await provider.forgotPassword(
                          email: usernameOrEmailController.text.trim(),
                        );
                        if (result) {
                          showTopSnackbar(
                            context,
                            'Link has been sent to your email',
                            1,
                          );
                          Navigator.pop(context);
                        } else {
                          showTopSnackbar(
                            context,
                            'Failed to send a link to your email',
                            2,
                          );
                        }
                        setDialogState(() {});
                      },
                      child: Text(
                        "Reset",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 4.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final sidebarProvider = context.watch<SidebarProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: SizedBox(
              width: 875,
              height: 600,
              child: BouncingImageBlobs(
                width: 875,
                height: 600,
                blobCount: 3,
                showShadow: true,
                images: const [
                  AssetImage('./assets/imgs/kingc.gif'),
                  AssetImage('./assets/imgs/queen.gif'),
                  AssetImage('./assets/imgs/joker.gif'),
                  // AssetImage('./assets/imgs/king.png'),
                  // AssetImage('./assets/imgs/queen.png'),
                  // AssetImage('./assets/imgs/jack.png'),
                ],
              ),
            ),
          ),

          // 🌟 Glow sits *behind* the button
          Positioned(
            top: 175,
            left: 125,
            child: Column(
              children: [
                Row(
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
                        fontSize: 16.sp,
                        fontFamily: 'RalewayBold',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    NeumorphicText(
                      ' Purple Ace',
                      style: NeumorphicStyle(
                        depth: 8,
                        intensity: 1,
                        surfaceIntensity: 0.2,
                        color: colorScheme.primary,
                        lightSource: LightSource.topLeft,
                      ),
                      textStyle: NeumorphicTextStyle(
                        fontSize: 26.sp,
                        fontFamily: 'AlissonReg',
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 35.h),

                Text(
                  'Sign in to your account',
                  style: TextStyle(fontFamily: 'RalewayReg', fontSize: 4.5.sp),
                ),
                SizedBox(height: 35.h),

                TextFieldNeumorphic(
                  width: 135.w,
                  height: 55.h,
                  type: 'username',
                  fontsize: 3.75.sp,
                  onChanged: (val) => authProvider.setUsername(val),
                ),
                SizedBox(height: 35.h),

                TextFieldNeumorphic(
                  width: 135.w,
                  height: 55.h,
                  fontsize: 3.75.sp,
                  type: 'password',
                  onChanged: (val) => authProvider.setPassword(val),
                ),

                SizedBox(height: 20.h),
                SizedBox(
                  width: 130.w,
                  child: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ValueListenableBuilder(
                        //   valueListenable: isCheckedNotifier,
                        //   builder: (context, bool isChecked, _) {
                        //     return Row(
                        //       children: [
                        //         Checkbox(
                        //           value: isChecked,
                        //           onChanged:
                        //               (value) =>
                        //                   isCheckedNotifier.value = value!,
                        //         ),
                        //         Text(
                        //           "Remember Me",
                        //           style: TextStyle(
                        //             fontFamily: 'RalewayReg',
                        //             fontSize: 3.5.sp,
                        //           ),
                        //         ),
                        //       ],
                        //     );
                        //   },
                        // ),
                        Row(
                          children: [
                            Text(
                              "Don't Have an Account? ",
                              style: TextStyle(
                                fontFamily: 'RalewayReg',
                                fontSize: 3.5.sp,
                              ),
                            ),
                            Text(
                              " Contact HR",
                              style: TextStyle(
                                fontFamily: 'RalewayReg',
                                fontSize: 3.5.sp,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              showAddEmployeeDialog(
                                provider: authProvider,
                                context: context,
                              );
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                fontFamily: 'RalewayReg',
                                fontSize: 3.5.sp,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 30.h),
                if (authProvider.errorMessage != null &&
                    !authProvider.isLoading)
                  SizedBox(
                    width: 125.w,
                    child: ShakeErrorWidget(
                      error: authProvider.errorMessage!,
                      offset: 2,
                      count: 4,
                      milliseconds: 350,
                    ),
                  ),
                Container(
                  height: 100.h,
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
                        authProvider.isLoading
                            ? LoadingIndicatorWidget(
                              size: 40.h,
                              textheight: 25.h,
                              key: const ValueKey('Loading...'),
                              isLoading: authProvider.isLoading,
                              loadingText: 'Signing in...',
                              backgroundColor: Colors.transparent,
                              type: LoadingAnimationType.discreteCircle,
                            )
                            : MouseRegion(
                              cursor:
                                  authProvider.allFilled
                                      ? SystemMouseCursors.click
                                      : SystemMouseCursors.basic,
                              child: PrettySlideGlowingButton(
                                text: 'Sign in',
                                width: 50.w,
                                height: 50.h,
                                key: const ValueKey('button'),
                                isActive: authProvider.allFilled,
                                username: authProvider.username,
                                onPressed:
                                    authProvider.isLoading ||
                                            !authProvider.allFilled
                                        ? null
                                        : () async {
                                          FocusScope.of(context).unfocus();

                                          final success =
                                              await authProvider.login();
                                          if (success) {
                                            sidebarProvider.setAllowedRoles(
                                              'user',
                                            );
                                            Navigator.pushNamed(
                                              context,
                                              DesktopNavigatorScreen.routeName,
                                            );
                                          } else {
                                            authProvider.resetFilled();
                                          }
                                        },
                              ),
                            ),
                  ),
                ),

                SizedBox(height: authProvider.isLoading ? 35.h : 10.h),
                // SizedBox(height: 15.h),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      final Uri url = Uri.parse('https://www.jdevelopss.com');

                      if (!await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      )) {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Image.asset(
                      './assets/imgs/jdevelops.png',
                      width: 20.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            right: -300,
            bottom: -500,
            child: NeumorphicGradientCircle(top: false, child: SizedBox()),
          ),
        ],
      ),
    );
  }
}

Widget _dialogField(
  String label,
  TextEditingController controller, {
  FocusNode? focusNode,
  FocusNode? nextFocus,
  Widget? prefix,
  Function(String)? onChanged,
  void Function()? onSubmittedLast,
  String? Function(String?)? validator,
  List<TextInputFormatter>? inputFormatters,
}) {
  return SizedBox(
    width: double.infinity,
    height: 50.h,
    child: TextFormField(
      controller: controller,
      focusNode: focusNode,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 3.5.sp,
        color: Colors.black,
      ),

      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 3.5.sp,
          color: Colors.black26,
        ),
        prefixIcon: prefix,
        // ✅ Normal Border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.black12, // ✅ default color
            width: 1.2, // ✅ thickness
          ),
        ),

        // ✅ Focused Border (when typing)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.purple, // ✅ focus color
            width: 1.2, // ✅ thicker on focus
          ),
        ),

        // ✅ Error Border (validation error)
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),

        // ✅ Focused Error Border
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 5.w),
      ),
      onChanged: onChanged,
      textInputAction:
          nextFocus != null ? TextInputAction.next : TextInputAction.done,
      onFieldSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(focusNode!.context!).requestFocus(nextFocus);
        } else {
          if (onSubmittedLast != null) onSubmittedLast();
        }
      },
      validator: validator,
      inputFormatters: inputFormatters,
    ),
  );
}
