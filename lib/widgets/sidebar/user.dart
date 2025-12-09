// packages
import 'package:flutter/material.dart';

// widgets
import '/widgets/sidebar/item.dart';

class SidebarUserPanel extends StatelessWidget {
  final bool isLoggedIn;
  final String? userName;
  final String? userRole; // e.g., 'admin', 'staff', 'guest'
  final VoidCallback? onLogout;
  final VoidCallback? onLogin;

  const SidebarUserPanel({
    super.key,
    required this.isLoggedIn,
    this.userName,
    this.userRole,
    this.onLogout,
    this.onLogin,
  });

  // Map user roles to icons
  IconData _getUserIcon() {
    switch (userRole) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'staff':
        return Icons.person_outline;
      case 'guest':
        return Icons.person;
      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final sidebarProvider = context.watch<SidebarProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isLoggedIn) ...[
          // User info
          SelectableGradientContainer(
            index: -1, // use -1 so it doesn’t conflict with menu items
            icon: _getUserIcon(),
            text: '$userName ($userRole)',
            onSelected: () {},
          ),

          // Logout button
          SelectableGradientContainer(
            index: -2,
            icon: Icons.logout,
            text: 'Logout',
            onSelected: onLogout,
          ),
        ] else ...[
          // Login button
          SelectableGradientContainer(
            index: -1,
            icon: Icons.login,
            text: 'Login',
            onSelected: onLogin,
          ),
        ],
      ],
    );
  }
}
