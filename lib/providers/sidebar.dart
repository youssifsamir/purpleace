// ignore_for_file: unused_field

// packages
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SidebarProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  final Map<String, List<String>> roleHierarchy = {
    'SuperAdmin': ['SuperAdmin', 'Admin', 'Manager', 'Cashier', 'Waiter'],
    'Admin': ['Admin', 'Manager', 'Cashier', 'Waiter'],
    'Manager': ['Manager', 'Cashier', 'Waiter'],
    'Cashier': ['Cashier', 'Waiter'],
    'Waiter': ['Waiter'],
  };

  final List<Map<String, dynamic>> _sidebarItems = [
    {
      'icon': FontAwesomeIcons.users,
      'text': 'Employees',
      'roles': ['SuperAdmin', 'Admin'],
    },
    {
      'icon': FontAwesomeIcons.ticket,
      'text': 'HR Tickets',
      'roles': ['SuperAdmin', 'Admin', 'Manager', 'Cashier'],
    },
    {
      'icon': FontAwesomeIcons.scaleBalanced,
      'text': 'Shifts & Rules',
      'roles': ['SuperAdmin', 'Admin', 'Manager', 'Cashier', 'Waiter'],
    },
  ];

  int get selectedIndex {
    if (_selectedIndex < 0 || _selectedIndex >= _sidebarItems.length) {
      return 0;
    }
    return _selectedIndex;
  }

  List<Map<String, dynamic>> get sidebarItems => _sidebarItems;

  void select(int index) {
    if (_selectedIndex == index) return;
    _selectedIndex = index;
    notifyListeners();
  }

  List<String>? _allowedRoles = ['SuperAdmin'];

  void setAllowedRoles(String userrole) {
    _allowedRoles = roleHierarchy[userrole];
    notifyListeners();
  }

  List<Map<String, dynamic>> get visibleSidebarItems => _sidebarItems.toList();
}
