import 'dart:math';

import 'package:challenges/pages/solar_system/models/planet.dart';
import 'package:challenges/utils/map_range.dart';
import 'package:flutter/material.dart';

class Sun {
  Sun({
    this.radius = 20.0,
    this.position = const Offset(0, 0),
    @required this.random,
    @required this.showMoons,
    this.planetAmount = 5,
  }) : planets = List<Planet>(random.nextInt(planetAmount) + 4)
            .asMap()
            .map((index, _) {
              final planetRadius =
                  random.nextInt((radius * .8).toInt()).toDouble();
              final angle = mapRange(random.nextDouble(), 0, 1, 0, 2 * pi);
              final distance = mapRange(random.nextDouble(), 0, 1,
                  radius + planetRadius, (radius + planetRadius) * 2);

              return MapEntry(
                index,
                Planet(
                  radius: planetRadius,
                  angle: angle,
                  distance: distance * index,
                  random: Random(),
                  level: 1,
                  showMoons: showMoons,
                ),
              );
            })
            .values
            .toList();

  final Offset position;
  final List<Planet> planets;
  final Random random;
  final double radius;
  final int planetAmount;
  final bool showMoons;

  void show(Canvas canvas, Size size, Paint paint) {
    canvas.drawCircle(position, radius, paint..color);
  }
}
