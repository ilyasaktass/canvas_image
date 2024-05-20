import 'package:canvas_image/canvas/models/menu_selected_items.dart';
import 'package:canvas_image/canvas/sidebar/sidebar_item.dart';
import 'package:canvas_image/canvas/sidebar/sidebar_list.dart';
import 'package:canvas_image/components/modal_widget.dart';
import 'package:canvas_image/constants/constants.dart';
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
  List<MenuSelectedItems> menuSelectedItems = [
    MenuSelectedItems(name: "pen", icon: const Icon(Icons.edit), show: true),
    MenuSelectedItems(
        name: "eraser", icon: const Icon(Icons.cleaning_services), show: true),
    MenuSelectedItems(
        name: "clearAll", icon: const Icon(Icons.clear), show: true),
    MenuSelectedItems(
        name: "square", icon: const Icon(Icons.crop_square), show: true),
    MenuSelectedItems(
        name: "circle",
        icon: const Icon(Icons.radio_button_unchecked),
        show: true),
    MenuSelectedItems(
        name: "line", icon: const Icon(Icons.linear_scale), show: true),
    MenuSelectedItems(
        name: "undo_redo", icon: const Icon(Icons.undo), show: true),
    MenuSelectedItems(
        name: "alignmentTools",
        icon: const Icon(Icons.format_align_left),
        show: true),
    MenuSelectedItems(
        name: "zoom", icon: const Icon(Icons.zoom_in), show: true),
    MenuSelectedItems(
        name: "colors", icon: const Icon(Icons.palette), show: true),
    MenuSelectedItems(
        name: "strokes", icon: const Icon(Icons.brush), show: true),
    MenuSelectedItems(
        name: "next_preview_image",
        icon: const Icon(Icons.arrow_back_ios),
        show: true),
    MenuSelectedItems(
        name: "recording", icon: const Icon(Icons.videocam), show: true),
  ];

  void showFeatureSelectionModal(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return CustomModal(
          top: 0,
          left: MediaQuery.of(context).size.width - sidebarWidth,
          right: 0,
          height: MediaQuery.of(context).size.height,
          items: menuSelectedItems,
          onItemSelect: (name, isSelected) {
            setState(() {
              menuSelectedItems.firstWhere((item) => item.name == name).show =
                  isSelected;
            });
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(animation),
          child: child,
        );
      },
    );
  }

  List<SidebarItem> _buildDrawingTools() {
    return [
      if (menuSelectedItems.firstWhere((item) => item.name == 'pen').show)
        SidebarItem(
          icon: const Icon(Icons.edit),
          onPressed: () => widget.toggleMode(DrawingMode.pen),
          isSelected: widget.drawingMode == DrawingMode.pen,
          selectedColor: Colors.white,
        ),
      if (menuSelectedItems.firstWhere((item) => item.name == 'eraser').show)
        SidebarItem(
          icon: const Icon(Icons.cleaning_services),
          onPressed: () => widget.toggleMode(DrawingMode.eraser),
          isSelected: widget.drawingMode == DrawingMode.eraser,
          selectedColor: Colors.white,
        ),
      if (menuSelectedItems.firstWhere((item) => item.name == 'clearAll').show)
        SidebarItem(
          icon: const Icon(Icons.clear),
          onPressed: () => widget.clearAll(),
        ),
      if (menuSelectedItems.firstWhere((item) => item.name == 'square').show)
        SidebarItem(
          icon: const Icon(Icons.crop_square),
          onPressed: () => widget.toggleMode(DrawingMode.rectangle),
          isSelected: widget.drawingMode == DrawingMode.rectangle,
          selectedColor: Colors.white,
        ),
      if (menuSelectedItems.firstWhere((item) => item.name == 'circle').show)
        SidebarItem(
          icon: const Icon(Icons.radio_button_unchecked),
          onPressed: () => widget.toggleMode(DrawingMode.circle),
          isSelected: widget.drawingMode == DrawingMode.circle,
          selectedColor: Colors.white,
        ),
      if (menuSelectedItems.firstWhere((item) => item.name == 'line').show)
        SidebarItem(
          icon: const Icon(Icons.linear_scale),
          onPressed: () => widget.toggleMode(DrawingMode.line),
          isSelected: widget.drawingMode == DrawingMode.line,
          selectedColor: Colors.white,
        ),
    ];
  }

  List<SidebarItem> _buildAlignmentTools() {
    if (!menuSelectedItems
        .firstWhere((item) => item.name == 'alignmentTools')
        .show) {
      return [];
    }

    return [
      SidebarItem(
        icon: const Icon(Icons.format_align_left),
        onPressed: () => widget.alignTopLeft(),
        isSelected: widget.imageAlignment == Alignment.topLeft,
        selectedColor: Colors.white,
      ),
      SidebarItem(
        icon: const Icon(Icons.format_align_center),
        onPressed: () => widget.alignTopCenter(),
        isSelected: widget.imageAlignment == Alignment.topCenter,
        selectedColor: Colors.white,
      ),
      SidebarItem(
        icon: const Icon(Icons.format_align_right),
        onPressed: () => widget.alignTopRight(),
        isSelected: widget.imageAlignment == Alignment.topRight,
        selectedColor: Colors.white,
      ),
    ];
  }

  List<SidebarItem> _buildZoomTools() {
    if (!menuSelectedItems.firstWhere((item) => item.name == 'zoom').show) {
      return [];
    }

    return [
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
  }

  List<SidebarItem> _buildColorTools() {
    if (!menuSelectedItems.firstWhere((item) => item.name == 'colors').show) {
      return [];
    }

    return [
      SidebarItem(
        icon: const Icon(Icons.palette),
        onPressed: () => widget.selectColor(Colors.black),
        isSelected: widget.selectedColor == Colors.black,
        selectedIcon: const Icon(Icons.check),
        color: Colors.black,
        selectedColor: Colors.black,
      ),
      SidebarItem(
        icon: const Icon(Icons.palette),
        onPressed: () => widget.selectColor(Colors.red),
        isSelected: widget.selectedColor == Colors.red,
        selectedIcon: const Icon(Icons.check),
        color: Colors.red,
        selectedColor: Colors.red,
      ),
      SidebarItem(
        icon: const Icon(Icons.palette),
        onPressed: () => widget.selectColor(Colors.blue),
        isSelected: widget.selectedColor == Colors.blue,
        selectedIcon: const Icon(Icons.check),
        color: Colors.blue,
        selectedColor: Colors.blue,
      ),
      SidebarItem(
        icon: const Icon(Icons.palette),
        onPressed: () => widget.selectColor(Colors.green),
        isSelected: widget.selectedColor == Colors.green,
        selectedIcon: const Icon(Icons.check),
        color: Colors.green,
        selectedColor: Colors.green,
      ),
      SidebarItem(
        icon: const Icon(Icons.palette),
        onPressed: () => widget.selectColor(Colors.yellow),
        isSelected: widget.selectedColor == Colors.yellow,
        selectedIcon: const Icon(Icons.check),
        color: Colors.yellow,
        selectedColor: Colors.yellow,
      ),
    ];
  }

  List<SidebarItem> _buildStrokeWidthTools() {
    if (!menuSelectedItems.firstWhere((item) => item.name == 'strokes').show) {
      return [];
    }

    return strokeList.map((item) {
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
  }

  List<SidebarItem> _buildBackgroundTools() {
    if (!menuSelectedItems
        .firstWhere((item) => item.name == 'next_preview_image')
        .show) {
      return [];
    }

    return [
      SidebarItem(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => widget.changeImageBackground(-1),
      ),
      SidebarItem(
        icon: const Icon(Icons.arrow_forward_ios),
        onPressed: () => widget.changeImageBackground(1),
      ),
    ];
  }

  List<SidebarItem> _buildUndoRedoTools() {
    if (!menuSelectedItems
        .firstWhere((item) => item.name == 'undo_redo')
        .show) {
      return [];
    }

    return [
      SidebarItem(
        icon: const Icon(Icons.undo),
        onPressed: () => widget.undo(),
      ),
      SidebarItem(
        icon: const Icon(Icons.redo),
        onPressed: () => widget.redo(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              children: [
                 IconButton(
                  onPressed: () {
                    showFeatureSelectionModal(context);
                  },
                  icon: const Icon(Icons.settings),
                ),
                SidebarList(items: _buildDrawingTools()),
                SidebarList(items: _buildAlignmentTools()),
                SidebarList(items: _buildZoomTools()),
                SidebarList(items: _buildUndoRedoTools()),
              ],
            ),
          ),
          Flexible(
            child: Column(
              children: [   
                SidebarList(items: _buildColorTools()),
                SidebarList(items: _buildStrokeWidthTools()),
                SidebarList(items: _buildBackgroundTools()),
                if (menuSelectedItems
                    .firstWhere((item) => item.name == 'recording')
                    .show)
                  const RecordScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
