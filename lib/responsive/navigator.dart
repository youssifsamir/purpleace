// packages
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

// layouts
import '/responsive/layouts.dart';

// screens
// import '/screens/desktop/navigator.dart';
import '../screens/mobile/navigator2.dart';

class ResponsiveNavigator extends StatelessWidget {
  const ResponsiveNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobilebody: MobileNavigatorScreen(),
      desktopbody: MobileNavigatorScreen(),
    );
  }
}
