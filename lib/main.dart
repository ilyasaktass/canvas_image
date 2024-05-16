import 'package:canvas_image/canvas/canvas_view.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp()); // const kaldırıldı

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // const kaldırıldı
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DrawingBoard(),
    );
  }
}
