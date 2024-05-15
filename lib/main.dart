import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImageLoader(),
    );
  }
}

class DrawingBoard extends StatefulWidget {
  final ui.Image backgroundImage;

  DrawingBoard({required this.backgroundImage});

  @override
  _DrawingBoardState createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  List<DrawnShape> _shapes = [];
  List<List<DrawnShape>> _undoneShapes = [];
  DrawingMode _drawingMode = DrawingMode.pen;
  Offset? _startPoint;
  Color _selectedColor = Colors.black; // Default color
  double _zoomLevel = 1.0;

  void toggleMode(DrawingMode mode) {
    setState(() {
      _drawingMode = mode;
      print("Drawing mode: $_drawingMode");
    });
  }

  void selectColor(Color color) {
    setState(() {
      _selectedColor = color;
      print("Selected color: $_selectedColor");
    });
  }

  void _undo() {
    if (_shapes.isNotEmpty) {
      _undoneShapes.add(List.from(_shapes));
      setState(() {
        _shapes.removeLast();
      });
    }
  }

  void _redo() {
    if (_undoneShapes.isNotEmpty) {
      setState(() {
        _shapes = _undoneShapes.removeLast();
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

  void _alignLeft() {
    setState(() {
      _zoomLevel = 1.0;
    });
  }

  void _alignCenter() {
    setState(() {
      _zoomLevel = 1.0;
    });
  }

  void _alignRight() {
    setState(() {
      _zoomLevel = 1.0;
    });
  }

  void _onPanStart(DragStartDetails details) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset point = renderBox.globalToLocal(details.localPosition) / _zoomLevel;

    if (_drawingMode != DrawingMode.eraser) {
      _startPoint = point;
      if (_drawingMode == DrawingMode.pen) {
        _shapes.add(DrawnShape(point, point, _drawingMode, _selectedColor));
      } else {
        _shapes.add(DrawnShape(point, point, _drawingMode, _selectedColor));
      }
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset point = renderBox.globalToLocal(details.localPosition) / _zoomLevel;

    setState(() {
      if (_drawingMode == DrawingMode.eraser) {
        _shapes.removeWhere((shape) => (shape.start - point).distance < 30);
      } else if (_startPoint != null) {
        if (_drawingMode == DrawingMode.pen) {
          _shapes.add(DrawnShape(_shapes.last.end, point, _drawingMode, _selectedColor));
        } else {
          _shapes.last.end = point;
        }
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _startPoint = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawing Board'),
        actions: [
          IconButton(
            icon: Icon(Icons.create),
            onPressed: () => toggleMode(DrawingMode.pen),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => toggleMode(DrawingMode.eraser),
          ),
          IconButton(
            icon: Icon(Icons.crop_square),
            onPressed: () => toggleMode(DrawingMode.rectangle),
          ),
          IconButton(
            icon: Icon(Icons.radio_button_unchecked),
            onPressed: () => toggleMode(DrawingMode.circle),
          ),
          IconButton(
            icon: Icon(Icons.linear_scale),
            onPressed: () => toggleMode(DrawingMode.line),
          ),
          // Diğer butonlar için benzer şekilde devam edebilirsiniz.
          SizedBox(width: 20), // Araya biraz boşluk ekleyelim
          // Renk seçimi için düğmeler
          IconButton(
            icon: Icon(Icons.palette),
            onPressed: () => selectColor(Colors.black),
            color: Colors.black,
          ),
          IconButton(
            icon: Icon(Icons.palette),
            onPressed: () => selectColor(Colors.red),
            color: Colors.red,
          ),
          IconButton(
            icon: Icon(Icons.palette),
            onPressed: () => selectColor(Colors.blue),
            color: Colors.blue,
          ),
          IconButton(
            icon: Icon(Icons.palette),
            onPressed: () => selectColor(Colors.green),
            color: Colors.green,
          ),
          IconButton(
            icon: Icon(Icons.palette),
            onPressed: () => selectColor(Colors.yellow),
            color: Colors.yellow,
          ),
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: _undo,
          ),
          IconButton(
            icon: Icon(Icons.redo),
            onPressed: _redo,
          ),
          IconButton(
            icon: Icon(Icons.zoom_in),
            onPressed: _zoomIn,
          ),
          IconButton(
            icon: Icon(Icons.zoom_out),
            onPressed: _zoomOut,
          ),
          IconButton(
            icon: Icon(Icons.zoom_out_map),
            onPressed: _resetZoom,
          ),
          IconButton(
            icon: Icon(Icons.align_horizontal_left),
            onPressed: _alignLeft,
          ),
          IconButton(
            icon: Icon(Icons.align_horizontal_center),
            onPressed: _alignCenter,
          ),
          IconButton(
            icon: Icon(Icons.align_horizontal_right),
            onPressed: _alignRight,
          ),
        ],
      ),
      body: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: Center(
          child: CustomPaint(
            painter: DrawingPainter(_shapes, widget.backgroundImage, _zoomLevel),
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

  DrawnShape(this.start, this.end, this.mode, this.color);
}

class DrawingPainter extends CustomPainter {
  final List<DrawnShape> shapes;
  final ui.Image backgroundImage;
  final double zoomLevel;

  DrawingPainter(this.shapes, this.backgroundImage, this.zoomLevel);

  @override
  void paint(Canvas canvas, Size size) {
    // Resmin boyutunu ölçeklendirme
    double scaledWidth = backgroundImage.width * zoomLevel;
    double scaledHeight = backgroundImage.height * zoomLevel;

    // Resmi çizme
    canvas.drawImageRect(
      backgroundImage,
      Rect.fromLTRB(0, 0, backgroundImage.width.toDouble(), backgroundImage.height.toDouble()),
      Rect.fromLTRB(0, 0, scaledWidth, scaledHeight),
      Paint(),
    );

    for (var shape in shapes) {
      Paint paint = Paint()
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 5.0
        ..color = shape.color;

      // Resmin boyutu ölçeklendirilerek çizim yapma
      Offset scaledStart = shape.start * zoomLevel;
      Offset scaledEnd = shape.end * zoomLevel;

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
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class ImageLoader extends StatefulWidget {
  @override
  _ImageLoaderState createState() => _ImageLoaderState();
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
      return Center(child: CircularProgressIndicator());
    }

    return DrawingBoard(backgroundImage: backgroundImage!);
  }
}

enum DrawingMode { pen, eraser, rectangle, circle, line, polygon }
