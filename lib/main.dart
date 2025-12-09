// ignore_for_file: deprecated_member_use

// packages
import 'dart:io';
import './firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// layouts
import '/responsive/login.dart';

// providers
import '/providers/auth.dart';
import '/providers/sidebar.dart';

// screens
import '/screens/mobile/login.dart';
import '/screens/desktop/home.dart';
import '/screens/desktop/login.dart';
import 'screens/mobile/navigator2.dart';
import '/screens/mobile/attendance.dart';
import '/screens/desktop/navigator.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('en');
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SidebarProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// ✅ Define your complete ColorScheme
final ColorScheme appColorScheme = const ColorScheme(
  brightness: Brightness.light,
  // primary: Color.fromARGB(255, 177, 132, 255),
  primary: Colors.purple,
  secondary: Colors.purpleAccent,
  error: Colors.red,
  surfaceTint: Color.fromARGB(255, 235, 122, 255),
  tertiary: Color.fromARGB(255, 162, 28, 73),

  onPrimary: Colors.white,
  primaryContainer: Color(0xFFE8EAF6),
  onPrimaryContainer: Color(0xFF1A237E),
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFFFE0B2),
  onSecondaryContainer: Color(0xFFBF360C),
  // tertiary: Color(0xFF26A69A), // Teal
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFFB2DFDB),
  onTertiaryContainer: Color(0xFF004D40),
  onError: Colors.white,
  errorContainer: Color(0xFFFFCDD2),
  onErrorContainer: Color(0xFFB71C1C),
  background: Color(0xFFF9FAFB),
  onBackground: Color(0xFF1F2937),
  surface: Colors.white,
  onSurface: Color(0xFF1F2937),
  surfaceVariant: Color(0xFFE5E7EB),
  onSurfaceVariant: Color(0xFF4B5563),
  outline: Color(0xFF9CA3AF),
  outlineVariant: Color(0xFFD1D5DB),
  shadow: Colors.black26,
  scrim: Colors.black45,
  inverseSurface: Color(0xFF111827),
  onInverseSurface: Colors.white,
  inversePrimary: Color(0xFF8C9EFF),
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 13 baseline
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Poppins',

            // ✅ Responsive Text Styles
            textTheme: TextTheme(
              displayLarge: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
              ),
              displayMedium: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.w600,
              ),
              displaySmall: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
              ),
              headlineMedium: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
              titleLarge: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
              bodyLarge: TextStyle(fontSize: 16.sp),
              bodyMedium: TextStyle(fontSize: 14.sp),
              labelLarge: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),

            // ✅ Full color scheme
            colorScheme: appColorScheme,
            useMaterial3: true,

            // ✅ Component themes
            appBarTheme: AppBarTheme(
              backgroundColor: appColorScheme.primary,
              foregroundColor: appColorScheme.onPrimary,
              elevation: 0,
              centerTitle: true,
            ),

            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: appColorScheme.primary,
              foregroundColor: appColorScheme.onPrimary,
            ),

            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: appColorScheme.primary,
                foregroundColor: appColorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
            ),

            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: appColorScheme.primary,
              ),
            ),
            cardColor: appColorScheme.surface,
            scaffoldBackgroundColor: appColorScheme.background,
          ),

          home: ResponsiveLoginScreen(),
          routes: {
            MobileLoginScreen.routeName: (_) => MobileLoginScreen(),
            AttendanceScreen.routeName: (_) => AttendanceScreen(),
            LoginScreens.routeName: (_) => LoginScreens(),
            DesktopHomeScreen.routeName: (_) => const DesktopHomeScreen(),
            MobileNavigatorScreen.routeName: (_) => MobileNavigatorScreen(),
            DesktopNavigatorScreen.routeName: (_) => DesktopNavigatorScreen(),
          },
        );
      },
    );
  }
}
