import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:challenges/pages/rotating_cube/models/cube.dart';
import 'package:challenges/pages/rotating_cube/models/geometry.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

final up = Vector3(0, -1, 0);
final xAxis = Vector3(1, 0, 0);
final yAxis = Vector3(0, 1, 0);
final zAxis = Vector3(0, 0, 1);

class RotatingCube extends StatefulWidget {
  @override
  RotatingCubeState createState() => RotatingCubeState();
}

class RotatingCubeState extends State<RotatingCube>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  final color = Colors.red[800];
  final strokeWidth = 2.0;
  final customPaintKey = GlobalKey();
  var _paused = false;
  // var autoRotate = false;
  var autoRotate = true;
  Timer _timer;

  Cube cube;
  var rotation = Offset.zero;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 365),
    );

    Future.delayed(Duration.zero, () {
      final context = customPaintKey.currentContext;
      if (context == null)
        throw 'Make sure to add the key \`customPaintKey\` to your `CustomPainter`.';

      final RenderBox box = context.findRenderObject();

      _setup(box.size);
    });

    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rotate the cube!')),
      floatingActionButton: FloatingActionButton(
        child: Icon(_paused ? Icons.play_arrow : Icons.pause),
        onPressed: _handlePress,
      ),
      body: SizedBox.expand(
        child: GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (_, __) {
                return CustomPaint(
                  key: customPaintKey,
                  painter: cube != null
                      ? CubePainter(_animationController, this)
                      : null,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _setup(Size size) {
    setState(() {
      cube = Cube(Vector3(0, 0, 0), min(size.width, size.height));
    });
  }

  void _handlePress() {
    if (_paused) {
      setState(() => _paused = false);
      _animationController.forward();
    } else {
      setState(() => _paused = true);
      _animationController.stop();
    }
  }

  void _onPanStart(_) {
    _timer?.cancel();
    autoRotate = false;
  }

  void _onPanEnd(_) {
    _timer = Timer(Duration(milliseconds: 2000), () {
      autoRotate = true;
    });
    rotation = Offset(0, 0);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    rotation = details.delta;
  }
}

class CubePainter extends CustomPainter {
  const CubePainter(this.animation, this.state) : super(repaint: animation);

  final Animation<double> animation;
  final RotatingCubeState state;

  @override
  void paint(Canvas canvas, Size size) {
    final brush = Paint()
      ..color = state.color
      ..strokeWidth = state.strokeWidth
      ..style = PaintingStyle.stroke;

    for (final vertex in state.cube.vertices) {
      vertex.applyAxisAngle(yAxis, state.rotation.dx / 180);
      vertex.applyAxisAngle(xAxis, state.rotation.dy / 180);
    }

    // Auto rotate
    if (state.autoRotate) {
      for (final vertex in state.cube.vertices) {
        vertex.applyAxisAngle(yAxis, -pi / 720);
        vertex.applyAxisAngle(Vector3(1, 0, 0), pi / 720);
      }
    }

    render([state.cube], canvas, size, brush);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  void render(List<Geometry> objects, Canvas canvas, Size size, Paint brush) {
    final dx = size.width / 2;
    final dy = size.height / 2;

    for (final object in objects) {
      for (final face in object.faces) {
        final path = Path();
        // Draw the first vertex
        var projection = project(face[0], size);

        path.moveTo(projection.dx + dx, -projection.dy + dy);

        // Draw the other vertices
        for (var k = 1; k < face.length; ++k) {
          projection = project(face[k], size);

          path.lineTo(projection.dx + dx, -projection.dy + dy);
        }

        // Close the path and draw the face
        path.close();
        canvas.drawPath(path, brush);
      }
    }
  }

  Offset project(Vector3 vertex, Size size) {
    // final orthographicMatrix = makeOrthographicMatrix(
    //   -size.width / 2,
    //   size.width / 2,
    //   -size.width / 2,
    //   size.width / 2,
    //   0,
    //   0,
    // );
    // final orthographicMatrix = makePerspectiveMatrix(pi / 4, 1, 0, 10.0);
    final viewMatrix = makeViewMatrix(
      Vector3(0, 0, -200),
      state.cube.center,
      Vector3(0, 1, 0),
    );

    // print('-------------------');
    // print(vertex);
    // print('###################');
    var vertexCopy = vertex.clone();
    vertexCopy.applyProjection(viewMatrix);
    vertexCopy = vertexCopy.scaled(.5);
    // print(vertex);
    // print('-------------------');

    return Offset(vertexCopy.x, vertexCopy.y);
    // return Offset(vertex.x, vertex.y);
  }
}
