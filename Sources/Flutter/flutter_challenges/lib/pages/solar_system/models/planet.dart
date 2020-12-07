import 'dart:math';

import 'package:challenges/utils/map_range.dart';
import 'package:flutter/material.dart';

class Planet {
  Planet({
    this.radius,
    this.distance = 0,
    @required this.angle,
    @required this.random,
    @required this.level,
    @required this.showMoons,
  })  : moons = level < 2
            ? List<Planet>(random.nextInt(5))
                .asMap()
                .map((index, _) {
                  final moonRadius =
                      (radius * (random.nextDouble() - .4).clamp(0, 1)) / level;
                  final moonDistance =
                      mapRange(random.nextDouble(), 0, 1, moonRadius, 20) /
                          level;
                  final angle = mapRange(random.nextDouble(), 0, 1, 0, 2 * pi);

                  return MapEntry(
                    index,
                    Planet(
                      angle: angle,
                      radius: moonRadius,
                      distance: radius + moonRadius + moonDistance,
                      random: Random(),
                      level: level + 1,
                      showMoons: showMoons,
                    ),
                  );
                })
                .values
                .toList()
            : [],
        orbitSpeed = 1 / sqrt(distance);

  final double radius;
  final int level;
  double angle;
  final double distance;
  final List<Planet> moons;
  final Random random;
  final double orbitSpeed;
  final bool showMoons;

  void orbit() {
    angle += orbitSpeed * .1;

    for (final moon in moons) {
      moon.orbit();
    }
  }

  void show(Canvas canvas, Size size, Paint paint) {
    canvas.save();
    canvas.rotate(angle);
    canvas.translate(distance, 0);
    canvas.drawCircle(Offset(0, 0), radius, paint);

    if (showMoons) {
      for (final moon in moons) {
        moon.show(canvas, size, paint);
      }
    }
    canvas.restore();
  }
}
