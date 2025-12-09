import 'package:flutter/material.dart';
import 'package:purpleace/screens/mobile/attendance.dart';
import 'package:purpleace/screens/mobile/login.dart';

class FloatingNavScreen extends StatefulWidget {
  const FloatingNavScreen({super.key});

  @override
  State<FloatingNavScreen> createState() => _FloatingNavScreenState();
}

class _FloatingNavScreenState extends State<FloatingNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    MobileLoginScreen(),
    AttendanceScreen(),
    AttendanceScreen(),
    AttendanceScreen(),
    AttendanceScreen(),
  ];

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      /// ✅ Body changes here
      body: _screens[_selectedIndex],

      /// ✅ Rounded Floating Navbar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _navItem(Icons.home, 0),
              _navItem(Icons.search, 1),
              _navItem(Icons.person, 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onTabChange(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.black : Colors.white,
          size: 26,
        ),
      ),
    );
  }
}
