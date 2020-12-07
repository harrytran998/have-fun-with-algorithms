import 'dart:ui' as UI;

import 'package:challenges/pages/invaders/models/flower.dart';
import 'package:flutter/material.dart';

class WaterDrop {
  WaterDrop(
    this.position, {
    @required this.image,
    this.velocity = const Offset(0, -4.0),
    this.dropSize = 40,
  });

  Offset position;
  final UI.Image image;
  // final Rect rect;
  Offset velocity;
  final double dropSize;
  bool isOffScreen = false;

  Rect get rect {
    return Rect.fromCenter(
      center: position,
      height: dropSize,
      width: dropSize,
    );
  }

  void show(Canvas canvas, Size size, Paint paint) {
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      rect,
      paint,
    );
  }

  void update(Duration deltaTime) {
    position += velocity;

    if (position.dy < 0) {
      isOffScreen = true;
    }
  }

  bool hits(Flower flower) {
    return rect.overlaps(flower.rect);
  }
}
