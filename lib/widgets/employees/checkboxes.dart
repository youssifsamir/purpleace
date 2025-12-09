// packages
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckboxGrid3x3 extends StatefulWidget {
  final Function(List<Map<String, dynamic>>)? onChanged;
  final List<Map<String, dynamic>> values;
  final bool permission;
  const CheckboxGrid3x3({
    super.key,
    this.onChanged,
    required this.permission,
    required this.values,
  });

  @override
  State<CheckboxGrid3x3> createState() => _CheckboxGrid3x3State();
}

class _CheckboxGrid3x3State extends State<CheckboxGrid3x3> {
  // Each checkbox has a value and a name

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.values.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 columns
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        childAspectRatio: 4, // short height
      ),
      itemBuilder: (context, index) {
        final item = widget.values[index];
        return Opacity(
          opacity: widget.permission ? 1 : 0.25,
          child: InkWell(
            focusColor:
                widget.permission
                    ? Colors.purple.withOpacity(0.15)
                    : Colors.transparent,
            highlightColor:
                widget.permission
                    ? Colors.purple.withOpacity(0.15)
                    : Colors.transparent,
            splashColor:
                widget.permission
                    ? Colors.purple.withOpacity(0.15)
                    : Colors.transparent,
            hoverColor:
                widget.permission
                    ? Colors.purple.withOpacity(0.15)
                    : Colors.transparent,
            onTap: () {
              if (widget.permission) {
                setState(() {
                  item['value'] = !item['value'];
                });
                widget.onChanged?.call(widget.values);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                // border: Border.all(color: Colors.black26),
                color:
                    item['value']
                        ? Colors.purple.withOpacity(0.15)
                        : Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: item['value'],
                    onChanged: (val) {
                      if (widget.permission) {
                        setState(() {
                          item['value'] = val!;
                        });
                        widget.onChanged?.call(widget.values);
                      }
                    },
                  ),
                  Flexible(
                    child: Text(
                      item['name'],
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: item['value'] ? Colors.purple : Colors.black26,
                        fontSize: 3.5.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
