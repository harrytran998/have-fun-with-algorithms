import 'dart:ui' as UI;

import 'package:flutter/material.dart';

class Food {
  Food(
    this.position,
    this.image, {
    @required this.width,
    @required this.height,
    this.key,
  });

  final Offset position;
  final UI.Image image;
  final double width;
  final double height;
  final Key key;

  void show(Canvas canvas, Size size, Paint paint) {
    // final oldColor = paint.color;

    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(position.dx, position.dy, width, height),
      paint,
    );

    // canvas.drawRect(
    //   Rect.fromLTWH(position.dx, position.dy, width, height),
    //   paint..color = Colors.blueGrey,
    // );
    // paint..color = oldColor;
  }
}
