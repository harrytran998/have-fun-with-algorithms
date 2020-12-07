import 'dart:math';
import 'dart:ui';

import 'package:fast_noise/fast_noise.dart' as fn;
import 'package:vector_math/vector_math_64.dart';

double doubleInRange(Random source, int start, int end) {
  return source.nextDouble() * (end - start) + start;
}

class Branch {
  Branch({
    this.initialOffset,
    this.visible = true,
  })  : points = [initialOffset],
        noise = SimplexNoise(),
        fastNoise = fn.PerlinNoise(octaves: 4, frequency: 0.15),
        random = Random(),
        speed = Point(
          doubleInRange(Random(), -3, 3),
          doubleInRange(Random(), -3, 3),
        );

  static final List<Color> colors = [];

  final Offset initialOffset;
  final SimplexNoise noise;
  final fn.PerlinNoise fastNoise;
  final Random random;
  final List<Offset> points;

  Point<double> speed;
  bool visible;

  void walls(Size size) {
    if (points.last.dx < 0 ||
        points.last.dx > size.width ||
        points.last.dy < 0 ||
        points.last.dy > size.height) {
      visible = false;
    }
  }

  void draw(Canvas canvas, Paint paint) {
    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      final prevPoint = i == 0 ? points[i] : points[i - 1];

      canvas.drawLine(prevPoint, point, paint..color = colors[i]);
    }
  }

  void moveStraight() {
    final point = points.last;

    final nextPoint = point.translate(speed.x, speed.y);

    points.add(nextPoint);
  }

  void moveRandom() {
    final point = points.last;

    speed += Point<double>(
      random.nextInt(15) - 7.0,
      random.nextInt(15) - 7.0,
    );

    final nextPoint = point.translate(speed.x, speed.y);
    points.add(nextPoint);
  }

  void moveNoise(double dt) {
    final point = points.last;
    // Higher number means more variability in the lines
    final alpha = 0.005;
    final timeScale = 0.0001;

    speed += Point(
      noise.noise3D(point.dx * alpha, point.dy * alpha, dt * timeScale),
      noise.noise3D(point.dx * alpha, point.dy * alpha, dt * timeScale),
    );

    final nextPoint = point.translate(speed.x, speed.y);

    points.add(nextPoint);
  }

  void movePerlin(double dt) {
    final point = points.last;

    final alpha = 0.05;

    speed += Point(
      fastNoise.getPerlin3(point.dx * alpha, point.dy * alpha, dt),
      fastNoise.getPerlin3(point.dx * alpha, point.dy * alpha, dt),
    );

    final nextPoint = point.translate(speed.x * .5, speed.y * .5);

    points.add(nextPoint);
  }
}
