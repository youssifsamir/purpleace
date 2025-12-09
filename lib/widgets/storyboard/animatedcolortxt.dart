import 'package:flutter/material.dart';

class HoverColorText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Color hoverColor;
  final Color defaultColor;
  final TextAlign textAlign;
  final int maxLines;
  final bool isHovered;

  const HoverColorText({
    super.key,
    required this.text,
    required this.isHovered,
    this.style,
    this.hoverColor = Colors.white,
    this.defaultColor = Colors.black,
    this.textAlign = TextAlign.center,
    this.maxLines = 1,
  });

  @override
  State<HoverColorText> createState() => _HoverColorTextState();
}

class _HoverColorTextState extends State<HoverColorText> {
  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 250),
      style: (widget.style ?? TextStyle()).copyWith(
        color: widget.isHovered ? widget.hoverColor : widget.defaultColor,
      ),
      child: Text(
        widget.text,
        maxLines: widget.maxLines,
        softWrap: true,
        textAlign: widget.textAlign,
      ),
    );
  }
}
