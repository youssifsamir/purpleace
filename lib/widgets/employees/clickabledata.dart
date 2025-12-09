// ignore_for_file: deprecated_member_use

// packages
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClickableDataWidget extends StatelessWidget {
  final int index, count, id;
  final VoidCallback? onTap;
  final String text;
  const ClickableDataWidget({
    super.key,
    this.onTap,
    required this.id,
    required this.text,
    required this.count,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = index == id;
    final colorScheme = Theme.of(context).colorScheme;

    final Color borderClr =
        isSelected ? colorScheme.primary : Colors.transparent;
    final Color containerClr =
        isSelected ? colorScheme.primary.withOpacity(0.1) : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        margin: EdgeInsets.only(top: 2.h, bottom: 2.h),
        width: id == 1 ? 75.w : 57.5.w,
        height: 45.h,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
        decoration: BoxDecoration(
          color: containerClr,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0 : 0.1),
              blurRadius: 6.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14.5.r),
            border: Border.all(color: borderClr, width: 0.6.w),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 2.w),
            decoration: BoxDecoration(
              color: containerClr,
              borderRadius: BorderRadius.circular(14.5.r),
              border: Border.all(color: Colors.white, width: 0.6.w),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 4.sp,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(width: 3.w),
                id == 1
                    ? Text(
                      "${count.toString()} EGP",
                      style: TextStyle(
                        fontSize: 4.sp,
                        fontFamily: 'Poppins',
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                    : Text(
                      count.toString(),
                      style: TextStyle(
                        fontSize: 4.sp,
                        fontFamily: 'Poppins',
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                // : AnimatedDigitWidget(
                //   value: count,
                //   textStyle: TextStyle(
                //     fontSize: 4.sp,
                //     fontFamily: isArabic ? "AlexReg" : 'PoppinsSemiBold',
                //     color: Colors.black87,
                //   ),
                // ),
                // if ("ok" == 'Delivery')
                //   Text(
                //     '${provider.selectedBranchId == -1 ? provider.totalOutEmployees : provider.totalOutEmployees} Active Out',
                //     style: TextStyle(
                //       fontSize: 3.sp,
                //       fontFamily: isArabic ? "AlexReg" : 'PoppinsMid',
                //       color: Colors.redAccent,
                //     ),
                //     textAlign: TextAlign.center,
                //     softWrap: true,
                //     overflow: TextOverflow.ellipsis,
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
