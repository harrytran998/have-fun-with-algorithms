import 'package:vector_math/vector_math.dart' hide Colors;

abstract class Geometry {
  List<Vector3> vertices;
  List<List<Vector3>> faces;
}
