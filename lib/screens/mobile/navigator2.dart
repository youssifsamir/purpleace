// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '/providers/sidebar.dart';

// screens

// widgets
import '/widgets/sidebar/sidebar.dart';

class MobileNavigatorScreen extends StatelessWidget {
  const MobileNavigatorScreen({super.key});
  static const routeName = './mobile/navigator.dart';

  @override
  Widget build(BuildContext context) {
    final sidebarProvider = context.watch<SidebarProvider>();

    // Define all the body pages you want to show
    final List<Widget> pages = [];

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
