import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

class Cell {
  Cell({
    @required this.position,
    @required this.color,
    @required this.simplexNoise,
    this.radius = 70,
  });

  final vm.SimplexNoise simplexNoise;
  Offset position;
  Color color;
  Offset velocity;
  double radius;

  void move(Size size, double time) {
    final xVelocity = simplexNoise.noise2D(position.dx, 0);
    final yVelocity = simplexNoise.noise2D(0, position.dy);

    velocity = Offset(xVelocity, yVelocity) * 10.0;

    position += velocity;
    position = Offset(
      position.dx.clamp(0 + radius, size.width - radius),
      position.dy.clamp(0 + radius, size.height - radius),
    );
  }

  void show(Canvas canvas, Size size, Paint paint) {
    canvas.drawCircle(position, radius, paint..color = color);
  }

  bool tapped(Offset tapLocation) {
    return (tapLocation - position).distance < radius;
  }

  List<Cell> mitosis() {
    final random = Random();

    return [
      Cell(
        position: position,
        simplexNoise: vm.SimplexNoise(),
        color: Color(random.nextInt(0xffffffff)),
        radius: radius / 1.4,
      ),
      Cell(
        position: position,
        simplexNoise: vm.SimplexNoise(),
        color: Color(random.nextInt(0xffffffff)),
        radius: radius / 1.4,
      ),
    ];
  }
}
