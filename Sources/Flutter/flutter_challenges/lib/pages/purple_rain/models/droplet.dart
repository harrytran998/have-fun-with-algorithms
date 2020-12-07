import 'dart:math';

import 'package:challenges/utils/map_range.dart';
import 'package:flutter/material.dart';

class Droplet {
  Droplet([this.position, this.velocity]);

  Offset position;
  Offset velocity;

  static final double maxSpeed = 11.0;
  static final double minSpeed = 6.0;

  void update(Size size, Random random) {
    position += velocity;

    if (position.dy > size.height) {
      randomPosition(size, random, true);
      randomVelocity(random);
    }

    if (position.dx > size.width) {
      position = Offset(
        position.dx - size.width,
        position.dy,
      );
    }

    if (position.dx < 0) {
      position = Offset(
        position.dx + size.width,
        position.dy,
      );
    }
  }

  void show(Canvas canvas, Paint paint) {
    canvas.drawLine(
      position,
      Offset(
        position.dx,
        position.dy + mapRange(velocity.dy, minSpeed, maxSpeed, 5, 10),
      ),
      paint
        ..color = Colors.purple
        ..strokeWidth = mapRange(velocity.dy, minSpeed, maxSpeed, 1, 6),
    );
  }

  Droplet randomPosition(Size size, [Random random, bool atTop = false]) {
    random ??= Random();

    position = Offset(
      mapRange(random.nextDouble(), 0, 1, 0, size.width),
      atTop
          ? -size.width
          : mapRange(random.nextDouble(), 0, 1, 0, -size.height * 2),
    );

    return this;
  }

  Droplet randomVelocity([Random random]) {
    random ??= Random();

    velocity = Offset(
      mapRange(random.nextDouble(), 0, 1, 0, 0.02),
      mapRange(random.nextDouble(), 0, 1, minSpeed, maxSpeed),
    );

    return this;
  }
}
