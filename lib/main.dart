import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Offset _startPosition = const Offset(0, 0);
  double _currentrRotation = 0;
  double _lastRotation = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Offset center = Offset(size.width * 0.5, size.height * 0.5);
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: CustomPaint(
            painter: _MyPainter(
              rotation: _lastRotation + _currentrRotation,
            ),
          ),
        ),
        onPanStart: (DragStartDetails details) {
          _startPosition = details.globalPosition;
        },
        onPanUpdate: (DragUpdateDetails details) {
          final Offset updatedPosition = details.globalPosition;

          final Vector2 a = Vector2(
            _startPosition.dx - center.dx,
            _startPosition.dy - center.dy,
          );
          final Vector2 b = Vector2(
            updatedPosition.dx - center.dx,
            updatedPosition.dy - center.dy,
          );

          final double dot = dot2(a, b);
          final double cross = cross2(a, b);

          final double radian = atan2(cross, dot);
          // double degree = degrees(radian);

          setState(() {
            _currentrRotation = radian;
          });
        },
        onPanEnd: (DragEndDetails details) {
          setState(() {
            _lastRotation += _currentrRotation;
            _currentrRotation = 0;
          });
        },
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  _MyPainter({this.rotation});
  double rotation;

  @override
  bool shouldRepaint(_MyPainter oldDelegate) {
    return rotation != oldDelegate.rotation;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final Rect rect = Rect.fromCircle(center: const Offset(0, 0), radius: 100);
    canvas.save();
    canvas.rotate(rotation);
    canvas.drawRect(rect, stroke);
    canvas.restore();
  }
}
