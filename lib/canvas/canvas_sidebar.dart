import 'package:canvas_image/enum/enums.dart';
import 'package:flutter/material.dart';
import 'package:canvas_image/record_screen/record_screen.dart';
class CanvasSidebar extends StatefulWidget {
  final Function toggleMode;
  final Function clearAll;
  final Function undo;
  final Function redo;
  final Function zoomIn;
  final Function zoomOut;
  final Function resetZoom;
  final Function alignTopLeft;
  final Function alignTopCenter;
  final Function alignTopRight;
  final Function selectColor;
  final double strokeWidth;
  final bool isFilled;
  final Function(bool?) toggleIsFilled;
  final Function(double) updateStrokeWidth;

  const CanvasSidebar({
    super.key,
    required this.toggleMode,
    required this.clearAll,
    required this.undo,
    required this.redo,
    required this.zoomIn,
    required this.zoomOut,
    required this.resetZoom,
    required this.alignTopLeft,
    required this.alignTopCenter,
    required this.alignTopRight,
    required this.selectColor,
    required this.strokeWidth,
    required this.isFilled,
    required this.toggleIsFilled,
    required this.updateStrokeWidth,
  });

  @override
  State<StatefulWidget> createState() {
    return _CanvasSidebarState();
  }
}

class _CanvasSidebarState extends State<CanvasSidebar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.create),
              onPressed: () => widget.toggleMode(DrawingMode.pen),
            ),
            IconButton(
              icon: const Icon(Icons.cleaning_services),
              onPressed: () => widget.toggleMode(DrawingMode.eraser),
            ),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => widget.clearAll(),
            ),
            IconButton(
              icon: const Icon(Icons.crop_square),
              onPressed: () => widget.toggleMode(DrawingMode.rectangle),
            ),
            IconButton(
              icon: const Icon(Icons.radio_button_unchecked),
              onPressed: () => widget.toggleMode(DrawingMode.circle),
            ),
            Checkbox(
              value: widget.isFilled,
              onChanged: (bool? value) => widget.toggleIsFilled(value),
              activeColor: Colors.black,
              checkColor: Colors.blue,
              splashRadius: 100,
            ),
            IconButton(
              icon: const Icon(Icons.linear_scale),
              onPressed: () => widget.toggleMode(DrawingMode.line),
            ),
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: () => widget.undo(),
            ),
            IconButton(
              icon: const Icon(Icons.redo),
              onPressed: () => widget.redo(),
            ),
            IconButton(
              icon: const Icon(Icons.zoom_in),
              onPressed: () => widget.zoomIn(),
            ),
            IconButton(
              icon: const Icon(Icons.zoom_out),
              onPressed: () => widget.zoomOut(),
            ),
            IconButton(
              icon: const Icon(Icons.zoom_out_map),
              onPressed: () => widget.resetZoom(),
            ),
            IconButton(
              icon: const Icon(Icons.align_horizontal_left),
              onPressed: () => widget.alignTopLeft(),
            ),
            IconButton(
              icon: const Icon(Icons.align_horizontal_center),
              onPressed: () => widget.alignTopCenter(),
            ),
            IconButton(
              icon: const Icon(Icons.align_horizontal_right),
              onPressed: () => widget.alignTopRight(),
            ),
            const RecordScreen(),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.palette),
              onPressed: () => widget.selectColor(Colors.black),
              color: Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.palette),
              onPressed: () => widget.selectColor(Colors.red),
              color: Colors.red,
            ),
            IconButton(
              icon: const Icon(Icons.palette),
              onPressed: () => widget.selectColor(Colors.blue),
              color: Colors.blue,
            ),
            IconButton(
              icon: const Icon(Icons.palette),
              onPressed: () => widget.selectColor(Colors.green),
              color: Colors.green,
            ),
            IconButton(
              icon: const Icon(Icons.palette),
              onPressed: () => widget.selectColor(Colors.yellow),
              color: Colors.yellow,
            ),
            SizedBox(
              width: 400,
              child: Slider(
                value: widget.strokeWidth,
                min: 1.0,
                max: 20.0,
                divisions: 19,
                label: widget.strokeWidth.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    widget.updateStrokeWidth(value);
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
