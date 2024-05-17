import 'package:canvas_image/canvas/sidebar/sidebar_item.dart';
import 'package:canvas_image/canvas/sidebar/sidebar_list.dart';
import 'package:canvas_image/enum/enums.dart';
import 'package:canvas_image/record_screen/record_screen.dart';
import 'package:flutter/material.dart';

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

  const CanvasSidebar({
    super.key,
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
    required this.changeImageBackground,
  });

  @override
  State<StatefulWidget> createState() {
    return _CanvasSidebarState();
  }
}

class _CanvasSidebarState extends State<CanvasSidebar> {
  final strokeList = [5, 8, 11, 14, 17];

  @override
  Widget build(BuildContext context) {
    List<SidebarItem> drawingTools = [
      SidebarItem(
        icon: const Icon(Icons.edit),
        onPressed: () => widget.toggleMode(DrawingMode.pen),
        isSelected: widget.drawingMode == DrawingMode.pen,
      ),
      SidebarItem(
        icon: const Icon(Icons.cleaning_services),
        onPressed: () => widget.toggleMode(DrawingMode.eraser),
        isSelected: widget.drawingMode == DrawingMode.eraser,
      ),
      SidebarItem(
        icon: const Icon(Icons.clear),
        onPressed: () => widget.clearAll(),
      ),
      SidebarItem(
        icon: const Icon(Icons.crop_square),
        onPressed: () => widget.toggleMode(DrawingMode.rectangle),
        isSelected: widget.drawingMode == DrawingMode.rectangle,
      ),
      SidebarItem(
        icon: const Icon(Icons.radio_button_unchecked),
        onPressed: () => widget.toggleMode(DrawingMode.circle),
        isSelected: widget.drawingMode == DrawingMode.circle,
      ),
      SidebarItem(
        icon: const Icon(Icons.linear_scale),
        onPressed: () => widget.toggleMode(DrawingMode.line),
        isSelected: widget.drawingMode == DrawingMode.line,
      ),
      SidebarItem(
        icon: const Icon(Icons.undo),
        onPressed: () => widget.undo(),
      ),
      SidebarItem(
        icon: const Icon(Icons.redo),
        onPressed: () => widget.redo(),
      ),
    ];

    List<SidebarItem> alignmentTools = [
      SidebarItem(
        icon: const Icon(Icons.format_align_left),
        onPressed: () => widget.alignTopLeft(),
        isSelected: widget.imageAlignment == Alignment.topLeft,
      ),
      SidebarItem(
        icon: const Icon(Icons.format_align_center),
        onPressed: () => widget.alignTopCenter(),
        isSelected: widget.imageAlignment == Alignment.topCenter,
      ),
      SidebarItem(
        icon: const Icon(Icons.format_align_right),
        onPressed: () => widget.alignTopRight(),
        isSelected: widget.imageAlignment == Alignment.topRight,
      ),
    ];

    List<SidebarItem> zoomTools = [
      SidebarItem(
        icon: const Icon(Icons.zoom_in),
        onPressed: () => widget.zoomIn(),
      ),
      SidebarItem(
        icon: const Icon(Icons.zoom_out),
        onPressed: () => widget.zoomOut(),
      ),
      SidebarItem(
        icon: const Icon(Icons.zoom_out_map),
        onPressed: () => widget.resetZoom(),
      ),
    ];

    List<SidebarItem> colorTools = [
      SidebarItem(
        icon: const Icon(Icons.palette),
        onPressed: () => widget.selectColor(Colors.black),
        isSelected: widget.selectedColor == Colors.black,
        selectedIcon: const Icon(Icons.check),
        color: Colors.black,
      ),
      SidebarItem(
        icon: const Icon(Icons.palette),
        onPressed: () => widget.selectColor(Colors.red),
        isSelected: widget.selectedColor == Colors.red,
        selectedIcon: const Icon(Icons.check),
        color: Colors.red,
      ),
      SidebarItem(
        icon: const Icon(Icons.palette),
        onPressed: () => widget.selectColor(Colors.blue),
        isSelected: widget.selectedColor == Colors.blue,
        selectedIcon: const Icon(Icons.check),
        color: Colors.blue,
      ),
      SidebarItem(
        icon: const Icon(Icons.palette),
        onPressed: () => widget.selectColor(Colors.green),
        isSelected: widget.selectedColor == Colors.green,
        selectedIcon: const Icon(Icons.check),
        color: Colors.green,
      ),
      SidebarItem(
        icon: const Icon(Icons.palette),
        onPressed: () => widget.selectColor(Colors.yellow),
        isSelected: widget.selectedColor == Colors.yellow,
        selectedIcon: const Icon(Icons.check),
        color: Colors.yellow,
      ),
    ];

    List<SidebarItem> strokeWidthTools = strokeList.map((item) {
      return SidebarItem(
        icon: Icon(Icons.circle_rounded, size: item.toDouble() + 8),
        onPressed: () {
          setState(() {
            widget.updateStrokeWidth(item.toDouble());
          });
        },
        isSelected: widget.strokeWidth == item.toDouble(),
        selectedIcon: const Icon(Icons.check),
        color: Colors.black,
      );
    }).toList();

    List<SidebarItem> backgroundTools = [
      SidebarItem(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => widget.changeImageBackground(-1),
      ),
      SidebarItem(
        icon: const Icon(Icons.arrow_forward_ios),
        onPressed: () => widget.changeImageBackground(1),
      ),
    ];

    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              children: [
                SidebarList(items: drawingTools),
                SidebarList(items: alignmentTools),
                SidebarList(items: zoomTools),
              ],
            ),
          ),
           Flexible(
            child: Column(
              children: [
                SidebarList(items: colorTools),
                SidebarList(items: strokeWidthTools),
                SidebarList(items: backgroundTools),
                const RecordScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
