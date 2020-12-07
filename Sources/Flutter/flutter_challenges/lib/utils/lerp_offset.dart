import 'package:flutter/material.dart';

/// Linearly interpolate between two Offsets.
Offset lerpOffset(Offset a, Offset b, double t) {
  if (a == null && b == null) return null;

  a ??= Offset.zero;
  b ??= Offset.zero;
  return a + (b - a) * t;
}
