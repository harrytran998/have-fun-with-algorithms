import 'dart:math';

import 'package:challenges/utils/map_range.dart';
import 'package:flutter/material.dart';

class Star {
  Star(this.position, this.z)
      : prevZ = z,
        random = Random(),
        speed = 20.0;

  final Random random;
  final double speed;

  double prevZ;
  Offset position;
  double z;

  void update(Size size) {
    z -= speed;

    if (z <= 1) {
      z = size.width;
      position = Offset(
        mapRange(random.nextDouble(), 0, 1, -size.width, size.width),
        mapRange(random.nextDouble(), 0, 1, -size.height, size.height),
      );

      prevZ = z;
    }
  }

  void show(Canvas canvas, Paint paint, Size size) {
    final sx = mapRange(position.dx / z, 0, 1, 0, size.width);
    final sy = mapRange(position.dy / z, 0, 1, 0, size.height);
    final radius = mapRange(z, 0, size.width, 16.0, 0);

    final mappedPosition = Offset(sx, sy);
    canvas.drawCircle(mappedPosition, radius, paint);

    final prevX = mapRange(position.dx / prevZ, 0, 1, 0, size.width);
    final prevY = mapRange(position.dy / prevZ, 0, 1, 0, size.height);

    canvas.drawLine(Offset(prevX, prevY), mappedPosition, paint);
  }
}
