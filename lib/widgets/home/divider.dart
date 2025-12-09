// packages
import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  final EdgeInsets? custompadding;
  final double? customthinckness;
  final Color? customcolor;
  const DividerWidget({
    super.key,
    this.custompadding,
    this.customthinckness,
    this.customcolor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: custompadding ?? EdgeInsets.all(0),
      child: Divider(
        color: customcolor ?? Colors.black12,
        thickness: customthinckness ?? 1.0,
      ),
    );
  }
}
