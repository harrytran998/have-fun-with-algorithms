import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class ThreeDimensional extends StatefulWidget {
  @override
  _ThreeDimensionalState createState() => _ThreeDimensionalState();
}

/// For a quick tutorial in 3d, I'd recommend http://www.opengl-tutorial.org/beginners-tutorials/tutorial-3-matrices/
/// For an understanding of transforms, see http://www.songho.ca/opengl/gl_transform.html
class _ThreeDimensionalState extends State<ThreeDimensional>
    with SingleTickerProviderStateMixin {
  final customPaintKey = GlobalKey();

  AnimationController controller;
  ThreeDimensionalPainter painter;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 365),
    );

    Future.delayed(Duration.zero, () {
      final context = customPaintKey.currentContext;
      final RenderBox box = context.findRenderObject();

      setState(() => painter = ThreeDimensionalPainter(controller, box.size));
      controller.forward();
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Soft Engine')),
      body: SizedBox.expand(
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              return CustomPaint(
                key: customPaintKey,
                painter: painter,
              );
            },
          ),
        ),
      ),
    );
  }
}

class Mesh {
  Mesh(this.name, this.verticesCount) : vertices = List(verticesCount);

  final String name;
  final int verticesCount;
  final List<Vector3> vertices;

  Vector3 rotation = Vector3.zero();
  Vector3 position = Vector3.zero();
}

// Normal vectors are also transformed from object coordinates to eye
// coordinates for lighting calculation. Note that normals are
// transformed in different way as vertices do. It is mutiplying the
// tranpose of the inverse of GL_MODELVIEW matrix by a normal vector.

class ThreeDimensionalPainter extends CustomPainter {
  ThreeDimensionalPainter(this.animation, this.size)
      : aspectRatio = size.width / size.height,
        super(repaint: animation) {
    cameraDistance = cameraPosition.distanceTo(lookAt);
    zNearPlane = cameraDistance - 0.1;
    zFarPlane = cameraDistance * 2.0;
    projectionMatrix = makePerspectiveMatrix(
      fovYRadians,
      aspectRatio,
      zNearPlane,
      zFarPlane,
    );
    viewMatrix = makeViewMatrix(cameraPosition, lookAt, up);
    modelMatrix = Matrix4.identity();
    mesh = Mesh("Cube", 8);
    mesh.vertices[0] = Vector3(-1, 1, 1);
    mesh.vertices[1] = Vector3(1, 1, 1);
    mesh.vertices[2] = Vector3(-1, -1, 1);
    mesh.vertices[3] = Vector3(-1, -1, -1);
    mesh.vertices[4] = Vector3(-1, 1, -1);
    mesh.vertices[5] = Vector3(1, 1, -1);
    mesh.vertices[6] = Vector3(1, -1, 1);
    mesh.vertices[7] = Vector3(1, -1, -1);
  }

  /// where you want to look at, in world space
  final Vector3 lookAt = Vector3(10, -30, 0);
  // final Vector3 lookAt = Vector3.zero();

  /// probably vector3(0,1,0), but (0,-1,0) would make you looking upside-down, which can be great too
  final Vector3 up = Vector3(0.0, 1.0, 0.0);

  /// the position of your camera, in world space
  final Vector3 cameraPosition = Vector3(0, 0.0, 300.0);

  /// The vertical Field of View, in radians: the amount of "zoom". Think "camera lens". Usually between 90° (extra wide) and 30° (quite zoomed in)
  final double fovYRadians = 0.78;

  /// Near clipping plane. Keep as big as possible, or you'll get precision issues.
  double zNearPlane;

  /// Far clipping plane. Keep as little as possible.
  double zFarPlane;

  /// The distance of the camera from target
  double cameraDistance;

  /// Projection matrix
  Matrix4 projectionMatrix;

  /// Camera matrix
  Matrix4 viewMatrix;

  /// Model matrix : an identity matrix (model will be at the origin)
  Matrix4 modelMatrix;

  /// Eye coordinates
  Matrix4 mv;

  /// Projection * View * Model (matrix multiplication is the other way around).
  /// Also known as clip coordinates. This matrix defines the viewing volume
  /// (frustum); how the vertex data are projected onto the screen (perspective
  /// or orthogonal).
  Matrix4 mvp;

  /// Aspect Ratio. Depends on the size of your window. Notice that 4/3 == 800/600 == 1280/960, sounds familiar ?
  final double aspectRatio;

  /// The size of the canvas
  final Size size;

  Mesh mesh;

  /// A listenable that will trigger a repaint in sync with the widget's animationController
  final Animation<double> animation;
  final brush = Paint()
    ..color = Colors.green
    ..strokeWidth = 3;

  final theta = pi / 480;
  final phi = pi / 560;

  final dt = 0.01;
  final sigma = 10.0;
  final rho = 28.0;
  final beta = 8.0 / 3.0;

  double x = 0.01;
  double y = 0.00;
  double z = 0.00;

  final points = <Vector3>[];

  @override
  void paint(Canvas canvas, Size size) {
    // Order is important
    // glm::mat4 myModelMatrix = myTranslationMatrix * myRotationMatrix * myScaleMatrix;
    // glm::vec4 myTransformedVector = myModelMatrix * myOriginalVector;
    modelMatrix.rotateX(theta);
    modelMatrix.rotateZ(phi);

    mv = viewMatrix * modelMatrix;
    mvp = projectionMatrix * mv;

    final dx = (sigma * (y - x)) * dt;
    final dy = (x * (rho - z) - y) * dt;
    final dz = ((x * y) - (beta * z)) * dt;
    x = x + dx;
    y = y + dy;
    z = z + dz;

    points.add(Vector3(x, y, z));

    // What the chuck?
    // final maxX = points.reduce((a, b) => max(a.x, b.x)).x;
    // final maxY = points.reduce((a, b) => max(a.y, b.y)).y;

    // GPU takes care of dividing by w, clipping those vertices
    // outside the cuboid area, flattening the image dropping
    // the z component, re-mapping everything from the -1 to 1
    // range into the 0 to 1 range and then scale it to the
    // viewport width and height, and rasterizing the triangles
    // to the screen (if you are doing the rasterization on the
    // CPU you will have to take care of these steps yourself).

    final projectedPoints = points.map<Offset>((vertex) {
      final vertexCopy = vertex.clone();

      /// A point in clip coordinates is represented with four components,
      vertexCopy.applyProjection(mvp);

      return Offset(
        (vertexCopy.x) * size.width + size.width / 2.0,
        -(vertexCopy.y) * size.height + size.height / 2.0,
      );
    }).toList();

    canvas.drawPoints(
      PointMode.polygon,
      projectedPoints,
      brush,
    );
  }

  @override
  bool shouldRepaint(ThreeDimensionalPainter old) => false;
}

bool matrixEqualEpsilon(Matrix4 left, Matrix4 right, double epsilon) {
  for (int i = 0; i < left.storage.length; ++i) {
    if ((left.storage[i] - right.storage[i]).abs() > epsilon) {
      return false;
    }
  }

  return true;
}
