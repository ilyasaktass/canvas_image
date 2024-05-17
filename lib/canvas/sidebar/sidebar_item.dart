import 'package:flutter/material.dart';
class SidebarItem {
  final Icon icon;
  final VoidCallback onPressed;
  final bool isSelected;
  final Icon? selectedIcon;
  final Color? color;

  SidebarItem({
    required this.icon,
    required this.onPressed,
    this.isSelected = false,
    this.selectedIcon,
    this.color,
  });
}
