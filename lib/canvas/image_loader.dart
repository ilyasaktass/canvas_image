import 'dart:async';
import 'dart:ui' as ui;

import 'package:canvas_image/canvas/canvas_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class ImageLoader extends StatefulWidget {
  const ImageLoader({super.key});
 @override
  State<StatefulWidget> createState() {
   return _ImageLoaderState();
  }
}

class _ImageLoaderState extends State<ImageLoader> {
  ui.Image? backgroundImage;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  Future<void> loadImage() async {
    final ByteData data = await rootBundle.load('assets/coin.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Image image = await decodeImageFromList(bytes);

    setState(() {
      backgroundImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (backgroundImage == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return DrawingBoard(backgroundImage: backgroundImage!);
  }
}