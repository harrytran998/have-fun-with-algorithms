import 'dart:math';

import 'package:challenges/utils/map_range.dart';
import 'package:flutter/material.dart';

class Bubble {
  Bubble(this.position, this.radius) : random = Random();

  final Random random;
  Offset position;
  double radius;

  void update(int deltaTime, Size size) {
    radius--;

    if (radius < 1) {
      radius = random.nextDouble() * 60.0;
      final newPosition = Offset(
        mapRange(random.nextDouble(), 0, 1, -size.width, size.width),
        mapRange(random.nextDouble(), 0, 1, -size.height, size.height),
      );

      position = newPosition;
    }
  }

  void show(Canvas canvas, Paint paint, Size size) {
    // double sx = mapRange(position.dx / position.dy, 0, 1, 0, size.width);
    // double sy = mapRange(position.dx / position.dy, 0, 1, 0, size.height);

    // canvas.drawCircle(Offset(sx, sy), radius, paint);

    canvas.drawCircle(position, radius, paint);
  }
}
