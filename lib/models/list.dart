// lib/widgets/custom_list.dart
import 'package:flutter/material.dart';

class StoryboardListData {
  String name;
  Color color;
  double width;
  double height;

  StoryboardListData({
    required this.name,
    this.color = const Color(0xFFE0E0E0),
    this.width = 300,
    this.height = 500,
  });
}
