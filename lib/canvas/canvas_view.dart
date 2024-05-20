import 'dart:ui' as ui;
import 'package:canvas_image/canvas/sidebar/canvas_sidebar.dart';
import 'package:canvas_image/constants/constants.dart';
import 'package:canvas_image/enum/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DrawingBoard extends StatefulWidget {
  const DrawingBoard({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DrawingBoardState();
  }
}

class _DrawingBoardState extends State<DrawingBoard> {
  ui.Image? backgroundImage;
  List<List<DrawnShape>> _shapesHistory = [];
  int _historyIndex = -1;
  List<DrawnShape> _currentShapes = [];
  DrawingMode _drawingMode = DrawingMode.pen;
  Offset? _startPoint;
  Color _selectedColor = Colors.black; // Default color
  double _zoomLevel = 1.0;
  Alignment _imageAlignment = Alignment.topLeft;
  bool _isFilled = false; // Checkbox for filled shapes
  double _strokeWidth = 5.0; // Slider for stroke width
  int _currentImageIndex = 1;
  final List<String> _images = [
    'assets/image1.png',
    'assets/image2.png',
    'assets/image3.png',
    'assets/image4.png',
    'assets/image5.png',
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky); // Hide system UI
    loadImage();
  }

  Future<void> loadImage() async {
    final ByteData data = await rootBundle.load(_images[_currentImageIndex]);
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Image image = await decodeImageFromList(bytes);

    setState(() {
      backgroundImage = image;
    });
  }

  void _changeImageBackground(int increment) {
    setState(() {
      _currentImageIndex += increment;
      if (_currentImageIndex < 0) {
        _currentImageIndex = _images.length - 1;
      } else if (_currentImageIndex >= _images.length) {
        _currentImageIndex = 0;
      }
      loadImage();
    });
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
    } else if (_historyIndex == 0) {
      setState(() {
        _historyIndex--;
        _currentShapes = [];
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

  void _toggleIsFilled(bool? value) {
    setState(() {
      _isFilled = value!;
    });
  }

  void _updateStrokeWidth(double value) {
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
        _currentShapes.removeWhere((shape) => _isPointInShape(point, shape));
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
      _historyIndex++;
    } else {
      _shapesHistory = _shapesHistory.sublist(0, _historyIndex + 1);
      _shapesHistory.add(List.from(_currentShapes));
      _historyIndex++;
    }
    setState(() {});
  }

  bool _isPointInShape(Offset point, DrawnShape shape) {
    switch (shape.mode) {
      case DrawingMode.pen:
      case DrawingMode.line:
        return (shape.start - point).distance <= _strokeWidth ||
            (shape.end - point).distance <= _strokeWidth;
      case DrawingMode.rectangle:
        Rect rect = Rect.fromPoints(shape.start, shape.end);
        return rect.contains(point);
      case DrawingMode.circle:
        double radius = (shape.start - shape.end).distance / 2;
        Offset center = (shape.start + shape.end) / 2;
        return (center - point).distance <= radius;
      default:
        return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          backgroundImage == null
              ? const Center(child: CircularProgressIndicator())
              : GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: Center(
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: DrawingPainter(
                          shapes: _currentShapes,
                          backgroundImage: backgroundImage!,
                          zoomLevel: _zoomLevel,
                          imageAlignment: _imageAlignment,
                          sidebarWidth: sidebarWidth,
                        ),
                        size: Size.infinite,
                      ),
                    ),
                  ),
                ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: Container(
              width: sidebarWidth, // Sidebar width
              decoration: BoxDecoration(
                color: const ui.Color.fromARGB(
                    255, 180, 170, 170), // Color moved to BoxDecoration
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.3), // Shadow color with opacity
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: const Offset(-2, 0), // Shadow offset (x, y)
                  ),
                ],
              ),
              child: CanvasSidebar(
                toggleMode: toggleMode,
                drawingMode: _drawingMode,
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
                selectedColor: _selectedColor,
                strokeWidth: _strokeWidth,
                isFilled: _isFilled,
                imageAlignment: _imageAlignment,
                toggleIsFilled: _toggleIsFilled,
                updateStrokeWidth: _updateStrokeWidth,
                changeImageBackground: _changeImageBackground,
              ),
            ),
          ),
        ],
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

  DrawnShape(this.start, this.end, this.mode, this.color, this.isFilled,
      this.strokeWidth);
}

class DrawingPainter extends CustomPainter {
  final List<DrawnShape> shapes;
  final ui.Image backgroundImage;
  final double zoomLevel;
  final Alignment imageAlignment;
  final double sidebarWidth;

  DrawingPainter({
    required this.shapes,
    required this.backgroundImage,
    required this.zoomLevel,
    required this.imageAlignment,
    required this.sidebarWidth,
  });

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
      offset = Offset(size.width - scaledWidth - sidebarWidth, 0);
    }

    // Resmi çizme
    canvas.drawImageRect(
      backgroundImage,
      Rect.fromLTRB(0, 0, backgroundImage.width.toDouble(),
          backgroundImage.height.toDouble()),
      Rect.fromLTWH(offset.dx, offset.dy, scaledWidth, scaledHeight),
      Paint(),
    );

    for (var shape in shapes) {
      Paint paint = Paint()
        ..strokeCap = StrokeCap.round
        ..strokeWidth = shape.strokeWidth
        ..color = shape.color
        ..style = shape.isFilled ? PaintingStyle.fill : PaintingStyle.stroke;

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
        default:
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
