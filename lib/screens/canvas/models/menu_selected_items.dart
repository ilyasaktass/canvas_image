import 'package:flutter/material.dart';

class MenuSelectedItems {
  final String name;
  final Icon icon;
  bool show;

  MenuSelectedItems({required this.name, required this.icon, this.show = false});
}
