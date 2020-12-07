import 'dart:ui' as UI;

import 'package:challenges/pages/invaders/models/watering_can.dart';
import 'package:flutter/material.dart';

/// Short for Flower Level. The choices are e: easy, m: medium, and h: hard.
/// The shorter name was to keep the letter count the same as "null". See `../levels.dart`.
enum Fl { e, m, h }

class Flower {
  Flower(
    this.position,
    this.flowerSize,
    this.image,
    this.level, {
    this.velocity = const Offset(1.0, 0),
  });

  Offset position;
  Offset velocity;
  double flowerSize;
  final UI.Image image;
  final Fl level;
  bool exploded = false;

  static final double maxFlowerSize = 60;

  Rect get rect {
    return Rect.fromCenter(
      center: position,
      height: flowerSize,
      width: flowerSize,
    );
  }

  static Duration currentTime = Duration.zero;
  static const Duration updateRate = Duration(microseconds: 333333); // TODO:

  void show(Canvas canvas, Size size, Paint paint) {
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      rect,
      paint,
    );
  }

  void grow() {
    switch (level) {
      case Fl.e:
        flowerSize += 5;
        break;
      case Fl.m:
        flowerSize += 3;
        break;
      case Fl.h:
        flowerSize += 2;
        break;
    }
  }

  void update(Duration deltaTime) {
    position += velocity;

    if (flowerSize > maxFlowerSize) {
      exploded = true;
    }
  }

  bool passedBottom(Size size) {
    return (position.dy + (flowerSize / 2)) > size.height;
  }

  bool hits(WateringCan wateringCan) {
    return rect.overlaps(wateringCan.rect);
  }

  bool hitEdge(Size size) {
    final hitLeft = (position.dx - (flowerSize / 2)) < 0;
    final hitRight = (position.dx + (flowerSize / 2)) > size.width;

    return hitLeft || hitRight;
  }
}
