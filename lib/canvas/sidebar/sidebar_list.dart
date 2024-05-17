import 'package:canvas_image/canvas/sidebar/sidebar_item.dart';
import 'package:canvas_image/constants/constants.dart';
import 'package:flutter/material.dart';
class SidebarList extends StatelessWidget {
  final List<SidebarItem> items;

  const SidebarList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        return IconButton(
          icon: item.isSelected ? item.selectedIcon ?? item.icon : item.icon,
          onPressed: item.onPressed,
          color: item.isSelected ? selectedColor : item.color ?? Colors.black,
        );
      }).toList(),
    );
  }
}


