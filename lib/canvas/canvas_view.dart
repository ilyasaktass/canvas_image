import 'dart:ui' as ui;

import 'package:canvas_image/canvas/canvas_sidebar.dart';
import 'package:canvas_image/enum/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DrawingBoard extends StatefulWidget {
  final ui.Image backgroundImage;

  const DrawingBoard({super.key, required this.backgroundImage});

  @override
  State<StatefulWidget> createState() {
    return _DrawingBoardState();
  }
}

class _DrawingBoardState extends State<DrawingBoard> {
  List<List<DrawnShape>> _shapesHistory = [];
  int _historyIndex = -1;
  List<DrawnShape> _currentShapes = [];
  DrawingMode _drawingMode = DrawingMode.pen;
  Offset? _startPoint;
  Color _selectedColor = Colors.black; // Default color
  double _zoomLevel = 1.0;
  Alignment _imageAlignment = Alignment.topLeft;
  bool _isFilled = true; // Checkbox for filled shapes
  double _strokeWidth = 5.0; // Slider for stroke width
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); // Hide system UI
  }

  void toggleMode(DrawingMode mode) {
    setState(() {
      _drawingMode = mode;
    });
  }

  void selectColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }
  void _undo() {
    if (_historyIndex > 0) {
      setState(() {
        _historyIndex--;
        _currentShapes = List.from(_shapesHistory[_historyIndex]);
      });
    }
  }

  void _redo() {
    if (_historyIndex < _shapesHistory.length - 1) {
      setState(() {
        _historyIndex++;
        _currentShapes = List.from(_shapesHistory[_historyIndex]);
      });
    }
  }

  void _zoomIn() {
    setState(() {
      _zoomLevel += 0.1;
    });
  }

  void _zoomOut() {
    setState(() {
      if (_zoomLevel > 0.1) {
        _zoomLevel -= 0.1;
      }
    });
  }

  void _resetZoom() {
    setState(() {
      _zoomLevel = 1.0;
    });
  }

  void _alignTopLeft() {
    setState(() {
      _imageAlignment = Alignment.topLeft;
    });
  }

  void _alignTopCenter() {
    setState(() {
      _imageAlignment = Alignment.topCenter;
    });
  }

  void _alignTopRight() {
    setState(() {
      _imageAlignment = Alignment.topRight;
    });
  }

  void _clearAll() {
    setState(() {
      _shapesHistory = [];
      _currentShapes = [];
      _historyIndex = -1;
    });
  }
  void _toggleIsFilled(bool? value){
    setState(() {
      _isFilled = value!;
    });
  }
  void _updateStrokeWidth(double value){
    setState(() {
      _strokeWidth = value;
    });
  }
  void _onPanStart(DragStartDetails details) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset point = renderBox.globalToLocal(details.localPosition);

    if (_drawingMode != DrawingMode.eraser) {
      _startPoint = point;
      setState(() {
        _currentShapes.add(DrawnShape(point, point, _drawingMode,
            _selectedColor, _isFilled, _strokeWidth));
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset point = renderBox.globalToLocal(details.localPosition);

    setState(() {
      if (_drawingMode == DrawingMode.eraser) {
        _currentShapes
            .removeWhere((shape) => (shape.start - point).distance < 30);
      } else if (_startPoint != null) {
        if (_drawingMode == DrawingMode.pen) {
          _currentShapes.add(DrawnShape(_currentShapes.last.end, point,
              _drawingMode, _selectedColor, _isFilled, _strokeWidth));
        } else {
          _currentShapes.last.end = point;
        }
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _startPoint = null;
    if (_historyIndex == -1 || _historyIndex == _shapesHistory.length - 1) {
      _shapesHistory.add(List.from(_currentShapes));
    } else {
      _shapesHistory = _shapesHistory.sublist(0, _historyIndex + 1);
      _shapesHistory.add(List.from(_currentShapes));
    }
    _historyIndex = _shapesHistory.length - 1;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: AppBar(
          backgroundColor: Colors.blueGrey,
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: CanvasSidebar(
              toggleMode: toggleMode,
              clearAll: _clearAll,
              undo: _undo,
              redo: _redo,
              zoomIn: _zoomIn,
              zoomOut: _zoomOut,
              resetZoom: _resetZoom,
              alignTopLeft: _alignTopLeft,
              alignTopCenter: _alignTopCenter,
              alignTopRight: _alignTopRight,
              selectColor: selectColor,
              strokeWidth: _strokeWidth,
              isFilled: _isFilled,
              toggleIsFilled: _toggleIsFilled,
              updateStrokeWidth: _updateStrokeWidth,
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: Center(
          child: CustomPaint(
            painter: DrawingPainter(_currentShapes, widget.backgroundImage,
                _zoomLevel, _imageAlignment),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

class DrawnShape {
  Offset start;
  Offset end;
  DrawingMode mode;
  Color color;
  bool isFilled;
  double strokeWidth;

  DrawnShape(this.start, this.end, this.mode, this.color, this.isFilled, this.strokeWidth);
}

class DrawingPainter extends CustomPainter {
  final List<DrawnShape> shapes;
  final ui.Image backgroundImage;
  final double zoomLevel;
  final Alignment imageAlignment;

  DrawingPainter(this.shapes, this.backgroundImage, this.zoomLevel, this.imageAlignment);

  @override
  void paint(Canvas canvas, Size size) {
    // Resmin boyutunu ölçeklendirme
    double scaledWidth = backgroundImage.width * zoomLevel;
    double scaledHeight = backgroundImage.height * zoomLevel;

    // Resmi hizalama
    Offset offset = Offset.zero;
    if (imageAlignment == Alignment.topLeft) {
      offset = Offset.zero;
    } else if (imageAlignment == Alignment.topCenter) {
      offset = Offset((size.width - scaledWidth) / 2, 0);
    } else if (imageAlignment == Alignment.topRight) {
      offset = Offset(size.width - scaledWidth, 0);
    }

    // Resmi çizme
    canvas.drawImageRect(
      backgroundImage,
      Rect.fromLTRB(0, 0, backgroundImage.width.toDouble(), backgroundImage.height.toDouble()),
      Rect.fromLTWH(offset.dx, offset.dy, scaledWidth, scaledHeight),
      Paint(),
    );

    for (var shape in shapes) {
      Paint paint = Paint()
        ..strokeCap = StrokeCap.round
        ..strokeWidth = shape.strokeWidth
        ..color = shape.color
        ..style = shape.isFilled ? PaintingStyle.fill : PaintingStyle.stroke;

      // Çizimleri direkt canvas üzerinde çizme
      Offset scaledStart = shape.start;
      Offset scaledEnd = shape.end;

      switch (shape.mode) {
        case DrawingMode.pen:
          canvas.drawLine(scaledStart, scaledEnd, paint);
          break;
        case DrawingMode.rectangle:
          canvas.drawRect(Rect.fromPoints(scaledStart, scaledEnd), paint);
          break;
        case DrawingMode.circle:
          double radius = (scaledStart - scaledEnd).distance / 2;
          Offset center = (scaledStart + scaledEnd) / 2;
          canvas.drawCircle(center, radius, paint);
          break;
        case DrawingMode.line:
          canvas.drawLine(scaledStart, scaledEnd, paint);
          break;
        // Polygon drawing can be added here.
        default:
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


