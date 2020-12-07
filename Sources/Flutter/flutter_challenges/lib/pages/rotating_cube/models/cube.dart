import 'package:challenges/pages/rotating_cube/models/geometry.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

class Cube extends Geometry {
  Cube(this.center, this.size) : d = size / 2 {
    vertices = [
      Vector3(center.x - d, center.y - d, center.z + d),
      Vector3(center.x - d, center.y - d, center.z - d),
      Vector3(center.x + d, center.y - d, center.z - d),
      Vector3(center.x + d, center.y - d, center.z + d),
      Vector3(center.x + d, center.y + d, center.z + d),
      Vector3(center.x + d, center.y + d, center.z - d),
      Vector3(center.x - d, center.y + d, center.z - d),
      Vector3(center.x - d, center.y + d, center.z + d)
    ];

    faces = [
      [vertices[0], vertices[1], vertices[2], vertices[3]],
      [vertices[3], vertices[2], vertices[5], vertices[4]],
      [vertices[4], vertices[5], vertices[6], vertices[7]],
      [vertices[7], vertices[6], vertices[1], vertices[0]],
      [vertices[7], vertices[0], vertices[3], vertices[4]],
      [vertices[1], vertices[6], vertices[5], vertices[2]]
    ];
  }

  final Vector3 center;
  final double size;
  final double d;
  List<Vector3> vertices;
  List<List<Vector3>> faces;
}
