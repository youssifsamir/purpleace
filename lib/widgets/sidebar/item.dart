// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// providers
import '/providers/sidebar.dart';

class SelectableGradientContainer extends StatelessWidget {
  final int index;
  final IconData icon;
  final String text;
  final VoidCallback? onSelected;

  const SelectableGradientContainer({
    super.key,
    required this.index,
    required this.icon,
    required this.text,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final sidebarProvider = context.watch<SidebarProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    final bool isSelected = sidebarProvider.selectedIndex == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          sidebarProvider.select(index);
          onSelected?.call();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AnimatedContainer(
              width: 52.5.w,
              height: 39.h,
              duration: Duration(milliseconds: isSelected ? 500 : 0),
              curve: Curves.ease,
              padding: EdgeInsets.only(left: 5.w, top: 10.h, bottom: 10.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors:
                      isSelected
                          ? [
                            colorScheme.primary.withOpacity(0.3),
                            colorScheme.primary.withOpacity(0.2),
                            colorScheme.primary.withOpacity(0.1),
                            colorScheme.primary.withOpacity(0),
                          ]
                          : [
                            Colors.white,
                            Colors.white,
                            Colors.white,
                            Colors.white,
                          ],
                  stops: const [0.0, 0.25, 0.5, 0.8],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    color:
                        // isSelected ? colorScheme.secondary : Colors.grey.shade600,
                        isSelected ? colorScheme.primary : Colors.black87,
                    size: 5.sp,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 3.sp,
                      fontFamily: 'PoppinsMid',
                      color:
                          // isSelected
                          //     ? colorScheme.secondary
                          //     : Colors.grey.shade600,
                          isSelected ? colorScheme.primary : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            AnimatedContainer(
              duration: Duration(milliseconds: isSelected ? 500 : 0),
              curve: Curves.easeInOut,
              width: 1.5.w,
              height: isSelected ? 39.h : 0.h,
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(2.r)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
