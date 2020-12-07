import 'package:challenges/pages/snake_game/models/food.dart';
import 'package:flutter/material.dart';

class Snake {
  Snake(
    Offset position,
    this.direction, {
    this.height,
    this.width,
  }) : tail = [position];

  Offset direction;

  bool hasEaten = false;
  final List<Offset> tail;
  final double height;
  final double width;

  Offset get head => tail.last; // Or tail.first;
  set head(Offset value) => tail[tail.length - 1] = value; // Or tail.first;

  bool ateItself() {
    for (final segment in tail.getRange(0, tail.length - 1)) {
      if ((segment - head).distance < 0.1) {
        return true;
      }
    }

    return false;
  }

  bool canEat(Offset foodPosition) {
    final distance = (head - foodPosition).distance;

    return distance < 1;
  }

  void eat(Food food) {
    tail.add(food.position + direction.scale(width, height));
    hasEaten = true;
  }

  void update(Duration deltaTime) {
    if (hasEaten) {
      hasEaten = false;
    } else {
      for (int i = 0; i < tail.length - 1; i++) {
        tail[i] = tail[i + 1];
      }

      head += direction.scale(width, height);
    }
  }

  void show(Canvas canvas, Paint paint, Size size) {
    paint = paint..color = Colors.greenAccent;

    for (final segment in tail) {
      canvas.drawRect(
        Rect.fromLTWH(segment.dx, segment.dy, width, height),
        paint,
      );
    }
  }
}
