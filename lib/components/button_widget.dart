import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {super.key,
      this.foregroundColor,
      this.backgroundColor,
      required this.onPressed,
      this.child,
      required this.padding,
      required this.size,
      });
  final Color? foregroundColor;
  final Color? backgroundColor;
  final VoidCallback onPressed;
  final Widget? child;
  final double size;
  final double padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      child: SizedBox(
        width: size,
        height: size,
        child: FloatingActionButton(
          mini: true,
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          onPressed: onPressed,
          child: child,
        ),
      ),
    );
  }
}
