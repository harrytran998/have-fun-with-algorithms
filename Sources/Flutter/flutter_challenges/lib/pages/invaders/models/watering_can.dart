import 'dart:ui' as UI;

import 'package:challenges/utils/lerp_offset.dart';
import 'package:flutter/material.dart';

class WateringCan {
  WateringCan(
    this.position, {
    @required this.image,
    this.targetPosition,
    this.canSize = 40,
    this.shootingRate = const Duration(microseconds: 16000),
  }) : timePassed = shootingRate;

  Offset position;
  final UI.Image image;
  Offset targetPosition;
  final double canSize;
  bool isShooting = false;
  Duration shootingRate;
  Duration timePassed;

  Rect get rect {
    return Rect.fromCenter(
      center: position,
      height: canSize,
      width: canSize,
    );
  }

  static Duration currentTime = Duration.zero;

  void show(Canvas canvas, Size size, Paint paint) {
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      rect,
      paint,
    );
  }

  void update(Duration deltaTime) {
    if (targetPosition != null) {
      position = lerpOffset(position, targetPosition, .1);
    }

    // currentTime += deltaTime;

    // if (currentTime > updateRate) {
    //   currentTime = Duration.zero;
    //   // lerpOffset(position, targetPosition, t);
    // }
  }
}
