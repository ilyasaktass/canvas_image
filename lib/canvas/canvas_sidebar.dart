import 'package:canvas_image/components/button_widget.dart';
import 'package:canvas_image/enum/enums.dart';
import 'package:flutter/material.dart';
import 'package:canvas_image/record_screen/record_screen.dart';

class CanvasSidebar extends StatefulWidget {
  final Function toggleMode;
  final DrawingMode drawingMode;
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
  final Color selectedColor;
  final double strokeWidth;
  final bool isFilled;
  final Alignment imageAlignment;
  final Function(bool?) toggleIsFilled;
  final Function(double) updateStrokeWidth;
  final Function(int) changeImageBackground;

  const CanvasSidebar(
      {super.key,
      required this.toggleMode,
      required this.drawingMode,
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
      required this.selectedColor,
      required this.strokeWidth,
      required this.isFilled,
      required this.imageAlignment,
      required this.toggleIsFilled,
      required this.updateStrokeWidth,
      required this.changeImageBackground});

  @override
  State<StatefulWidget> createState() {
    return _CanvasSidebarState();
  }
}

class _CanvasSidebarState extends State<CanvasSidebar> {
  final strokeList = [5, 10, 15, 20, 25];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => widget.toggleMode(DrawingMode.pen),
              color: widget.drawingMode == DrawingMode.pen
                  ? Colors.blue
                  : Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.cleaning_services),
              onPressed: () => widget.toggleMode(DrawingMode.eraser),
              color: widget.drawingMode == DrawingMode.eraser
                  ? Colors.blue
                  : Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => widget.clearAll(),
              color: Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.crop_square),
              onPressed: () => widget.toggleMode(DrawingMode.rectangle),
              color: widget.drawingMode == DrawingMode.rectangle
                  ? Colors.blue
                  : Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.radio_button_unchecked),
              onPressed: () => widget.toggleMode(DrawingMode.circle),
              color: widget.drawingMode == DrawingMode.circle
                  ? Colors.blue
                  : Colors.black,
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
              color: widget.drawingMode == DrawingMode.line
                  ? Colors.blue
                  : Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: () => widget.undo(),
              color: Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.redo),
              onPressed: () => widget.redo(),
              color: Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.zoom_in),
              onPressed: () => widget.zoomIn(),
              color: Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.zoom_out),
              onPressed: () => widget.zoomOut(),
              color: Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.zoom_out_map),
              onPressed: () => widget.resetZoom(),
              color: Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.format_align_left),
              onPressed: () => widget.alignTopLeft(),
              color: widget.imageAlignment == Alignment.topLeft
                  ? Colors.blue
                  : Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.format_align_center),
              onPressed: () => widget.alignTopCenter(),
              color: widget.imageAlignment == Alignment.topCenter
                  ? Colors.blue
                  : Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.format_align_right),
              onPressed: () => widget.alignTopRight(),
              color: widget.imageAlignment == Alignment.topRight
                  ? Colors.blue
                  : Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => widget.changeImageBackground(-1),
              color: Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () => widget.changeImageBackground(1),
              color: Colors.black,
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
              selectedIcon: widget.selectedColor == Colors.black
                  ? const Icon(Icons.check)
                  : const Icon(Icons.palette),
              isSelected: widget.selectedColor == Colors.black ? true : false,
            ),
            IconButton(
              icon: const Icon(Icons.palette),
              onPressed: () => widget.selectColor(Colors.red),
              color: Colors.red,
              selectedIcon: widget.selectedColor == Colors.red
                  ? const Icon(Icons.check)
                  : const Icon(Icons.palette),
              isSelected: widget.selectedColor == Colors.red ? true : false,
            ),
            IconButton(
              icon: const Icon(Icons.palette),
              onPressed: () => widget.selectColor(Colors.blue),
              color: Colors.blue,
              selectedIcon: widget.selectedColor == Colors.blue
                  ? const Icon(Icons.check)
                  : const Icon(Icons.palette),
              isSelected: widget.selectedColor == Colors.blue ? true : false,
            ),
            IconButton(
              icon: const Icon(Icons.palette),
              onPressed: () => widget.selectColor(Colors.green),
              color: Colors.green,
              selectedIcon: widget.selectedColor == Colors.green
                  ? const Icon(Icons.check)
                  : const Icon(Icons.palette),
              isSelected: widget.selectedColor == Colors.green ? true : false,
            ),
            IconButton(
              icon: const Icon(Icons.palette),
              onPressed: () => widget.selectColor(Colors.yellow),
              color: Colors.yellow,
              selectedIcon: widget.selectedColor == Colors.yellow
                  ? const Icon(Icons.check)
                  : const Icon(Icons.palette),
              isSelected: widget.selectedColor == Colors.yellow ? true : false,
            ),
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: strokeList.map((item) {
                return IconButton(
                  icon: const Icon(Icons.circle_rounded),
                  iconSize: item.toDouble() + 8,
                  onPressed: () {
                    setState(() {
                      widget.updateStrokeWidth(item.toDouble());
                    });
                  },
                  color: Colors.black,
                  selectedIcon: widget.strokeWidth == item
                      ? const Icon(Icons.check)
                      : const Icon(Icons.circle_rounded),
                  isSelected: widget.strokeWidth == item ? true : false,
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}
