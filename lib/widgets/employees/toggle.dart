// ignore_for_file: deprecated_member_use, use_super_parameters

// packages
import 'package:flutter/material.dart';

class TextSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const TextSwitch({Key? key, required this.value, required this.onChanged})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 100,
        height: 25,
        padding: EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          color: value ? Colors.green : Colors.red.withOpacity(0.25),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: Duration(milliseconds: 200),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                  left: value ? 0 : 20,
                  right: value ? 20 : 0,
                ),
                child: Text(
                  value ? "ACTIVE" : "UNACTIVE",
                  style: TextStyle(
                    fontFamily: 'PoppinsBold',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
