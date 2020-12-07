import 'package:flutter/material.dart';

class Branch {
  Branch(this.parent, this.position, this.direction)
      : originalDirection = direction;

  final Offset position;
  final Branch parent;
  Offset direction;
  final Offset originalDirection;
  int count = 0;

  void reset() {
    direction = originalDirection;
    count = 0;
  }

  Branch next() {
    final nextPosition = position + direction;

    return Branch(this, nextPosition, direction);
  }

  show(Canvas canvas, Paint paint) {
    if (parent != null) {
      canvas.drawLine(position, parent.position, paint);
    }
  }
}
