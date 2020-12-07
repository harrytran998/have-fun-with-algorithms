import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as UI;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

// Largely inspired by https://github.com/flutter/flutter/issues/19794

final up = Vector3(0.0, 1.0, 0.0);

class TerrainGeneration extends StatefulWidget {
  @override
  TerrainGenerationState createState() => TerrainGenerationState();
}

class TerrainGenerationState extends State<TerrainGeneration>
    with SingleTickerProviderStateMixin {
  // Fields private to this class
  AnimationController _animationController;
  final _customPaintKey = GlobalKey();
  bool _isInitialized = false;

  // Accessible in TerrainGenerationPainter.
  // There is no need to setState after updating these
  // They'll update with every vsync tick.
  int columns, rows;
  List<List<double>> terrain;
  double scale = 40.0;
  var flying = 0.0;
  final simplexNoise = SimplexNoise();

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(days: 365),
    );

    // Await the build phase to be complete in order to get sizing
    Future.delayed(Duration.zero, () {
      final context = _customPaintKey.currentContext;
      final RenderBox box = context.findRenderObject();

      setup(box.size);
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
    final backgroundColor = Colors.grey[800];

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text('Waves'),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SizedBox.expand(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              child: MusicPlayer(),
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  child: child,
                  key: _customPaintKey,
                  painter: _isInitialized
                      ? TerrainGenerationPainter(_animationController, this)
                      : null,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void setup(Size size) {
    final width = size.width;
    // Add extra columns to help it fill the width of the screen
    columns = width ~/ scale + 16;
    rows = size.height ~/ scale;

    terrain = List.generate(
      columns,
      (_) => List.generate(rows, (_) => 0.0),
    );

    setState(() => _isInitialized = true);
  }
}

class MusicPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bottomColor = Color(0xff1E1F25);
    final fontStyle = GoogleFonts.rajdhani();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://images.squarespace-cdn.com/content/57ae2da915d5db42067fce41/1581060108307-TRO66FA2E9EX1XVJ0LTE/MISUNDERSTOOD.png?format=1000w&content-type=image%2Fpng',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Misunderstood',
                        style: fontStyle.copyWith(fontSize: 32.0),
                      ),
                      Text(
                        'Xuitcasecity',
                        style: fontStyle.copyWith(
                          fontSize: 24.0,
                          color: Colors.white.withOpacity(.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            flex: 3,
                            child: Container(
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 5,
                            child: Container(
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.7),
                                borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '1:15',
                            style: fontStyle.copyWith(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '3:47',
                            style: fontStyle.copyWith(
                              fontSize: 20.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Material(
          color: bottomColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(36.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 32.0, top: 42.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.skip_previous),
                      iconSize: 56,
                      onPressed: () {},
                    ),
                    Container(
                      decoration: ShapeDecoration(
                        shape: CircleBorder(),
                        color: Colors.white,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.play_arrow,
                          color: bottomColor,
                        ),
                        iconSize: 56,
                        onPressed: () {},
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.skip_next),
                      iconSize: 56,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      color: Colors.grey,
                      icon: Icon(Icons.repeat),
                      onPressed: () {},
                    ),
                    IconButton(
                      color: Colors.grey,
                      icon: Icon(Icons.thumb_up),
                      onPressed: () {},
                    ),
                    IconButton(
                      color: Colors.grey,
                      icon: Icon(Icons.search),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TerrainGenerationPainter extends CustomPainter {
  const TerrainGenerationPainter(this.animation, this.state)
      : super(repaint: animation);

  final Animation<double> animation;
  final TerrainGenerationState state;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = state.scale;
    final width = size.width;
    final height = size.height;
    final cameraPosition = Vector3(0, 0, 6);
    var brush = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4
      ..style = PaintingStyle.fill;

    final lookAt = Vector3.zero();
    final cameraDistance = cameraPosition.distanceTo(lookAt);
    final aspectRatio = width / height;
    final zNearPlane = cameraDistance - 0.1;
    final zFarPlane = cameraDistance * 2;
    final fovYRadians = 0.7;
    // Build matrices to get us into an OpenGL-like coordinate space
    // bottom left corner of the screen is at (-1, -1), top right is at (1, 1)
    final toOpenGlCoords = Matrix4.compose(
      Vector3(-1.0, 1.0, 0.0),
      Quaternion.axisAngle(Vector3(1.0, 0.0, 0.0), pi),
      Vector3(2 / width, 2 / height, 1.0),
    );
    final toFlutterCoords = Matrix4.tryInvert(toOpenGlCoords);
    final modelMatrix = Matrix4.rotationX(-pi / 2.3).scaled(1.0, 4.5, 1.0);
    final viewMatrix = makeViewMatrix(cameraPosition, lookAt, up);
    final projectionMatrix = makePerspectiveMatrix(
      fovYRadians,
      aspectRatio,
      zNearPlane,
      zFarPlane,
    );
    // Sometimes the view matrix and model matrix are premultiplied and
    // stored as a model-view matrix. While each object has its own
    // model matrix, the view matrix is shared by all objects in the
    // scene, as they are all rendered from the same camera. Given a
    // camera's model matrix C, any vector v can be transformed from
    // model space, to world space, to camera space.
    final mvp = projectionMatrix * viewMatrix * modelMatrix;
    final flutterCompatTransform = toFlutterCoords * mvp * toOpenGlCoords;

    state.flying -= 0.01;
    var yOff = state.flying;
    for (int y = 0; y < state.rows; y++) {
      var xOff = 0.0;
      for (int x = 0; x < state.columns; x++) {
        state.terrain[x][y] = state.simplexNoise.noise2D(xOff, yOff) * .25;
        xOff += 0.1;
      }
      yOff += 0.1;
    }

    final List<List<Vector3>> allVertices = [];

    // To Account for all those columns I added in order to fill the space
    canvas.translate(-100, 0);

    for (int y = 0; y < state.rows - 1; y++) {
      allVertices.add([]);

      for (int x = 0; x < state.columns; x++) {
        final vertices = allVertices[y];

        vertices.add(
          Vector3(x * scale, y * scale, state.terrain[x][y]),
        );
        vertices.add(
          Vector3(x * scale, (y + 1) * scale, state.terrain[x][y + 1]),
        );
      }
    }

    for (final vertices in allVertices) {
      final projected = vertices.map<Vector2>((vertex) {
        final vertexCopy = vertex.clone();
        vertexCopy.applyProjection(flutterCompatTransform);

        return Vector2(vertexCopy.x, vertexCopy.y);
      }).toList();
      final storage = _encodeVector2List(projected);

      canvas.drawVertices(
        UI.Vertices.raw(
          VertexMode.triangleStrip,
          storage,
        ),
        BlendMode.dstIn,
        brush,
      );
    }
  }

  // This is copied from dart:ui
  Float32List _encodeVector2List(List<Vector2> vertices) {
    final int pointCount = vertices.length;
    final Float32List result = Float32List(pointCount * 2);

    for (int i = 0; i < pointCount; ++i) {
      final int xIndex = i * 2;
      final int yIndex = xIndex + 1;
      final Vector2 point = vertices[i];
      result[xIndex] = point.x;
      result[yIndex] = point.y;
    }

    return result;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
