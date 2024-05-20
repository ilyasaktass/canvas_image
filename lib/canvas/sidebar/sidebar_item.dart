import 'package:flutter/material.dart';
class SidebarItem {
  final Icon icon;
  final VoidCallback onPressed;
  bool isSelected;
  final Icon? selectedIcon;
  final Color? color;
  Color? selectedColor = Colors.white;

  SidebarItem({
    required this.icon,
    required this.onPressed,
    this.isSelected = false,
    this.selectedIcon,
    this.color,
    this.selectedColor
  });
}
