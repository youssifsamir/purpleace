// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '/providers/sidebar.dart';

// widgets
import 'item.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final sidebarProvider = context.watch<SidebarProvider>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(sidebarProvider.sidebarItems.length, (index) {
        final item = sidebarProvider.sidebarItems[index];
        return SelectableGradientContainer(
          index: index,
          icon: item['icon'],
          text: item['text'],
          onSelected: () {
            debugPrint('Selected: ${item['text']}');
          },
        );
      }),
    );
  }
}
