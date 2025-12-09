// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purpleace/screens/desktop/home.dart';

// providers
import '/providers/sidebar.dart';

// screens
import './employees.dart';
// import '../storyboard.dart';

// widgets
import '/widgets/sidebar/sidebar.dart';

class DesktopNavigatorScreen extends StatelessWidget {
  const DesktopNavigatorScreen({super.key});
  static const routeName = './desktop/navigator.dart';

  @override
  Widget build(BuildContext context) {
    final sidebarProvider = context.watch<SidebarProvider>();

    // Define all the body pages you want to show
    final List<Widget> pages = [
      DesktopHomeScreen(),
      EmployeesScreen(),
      EmployeesScreen(),
      EmployeesScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          /// 🟩 Sidebar always visible
          const SidebarWidget(),

          /// 🟦 Main body (changes based on selected index)
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: pages[sidebarProvider.selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
