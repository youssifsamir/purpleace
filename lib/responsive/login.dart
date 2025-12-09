// packages
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

// layouts
import '/responsive/layouts.dart';

// screens
import '/screens/desktop/login.dart';
import '/screens/mobile/login.dart';

class ResponsiveLoginScreen extends StatelessWidget {
  const ResponsiveLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobilebody: MobileLoginScreen(),
      desktopbody: LoginScreens(),
    );
  }
}
