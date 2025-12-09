// packages
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoWithName extends StatelessWidget {
  final String logoPath;
  final double logoSize;

  const LogoWithName({super.key, required this.logoPath, this.logoSize = 36});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      logoPath,
      width: logoSize.w,
      height: logoSize.w,
      fit: BoxFit.contain,
    );
  }
}
