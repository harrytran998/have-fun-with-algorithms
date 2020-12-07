import 'dart:math';

import 'package:flutter/material.dart';

class Cell {
  Cell({
    @required this.i,
    @required this.j,
    @required this.length,
    @required this.random,
  })  : top = true,
        right = true,
        bottom = true,
        left = true;

  final int i;
  final int j;

  final double length;
  final Random random;

  bool top, right, bottom, left;
  var visited = false;

  void show(Canvas canvas, Size size, Paint paint) {
    final x = i * length;
    final y = j * length;

    if (top) {
      canvas.drawLine(Offset(x, y), Offset(x + length, y), paint);
    }

    if (right) {
      canvas.drawLine(
        Offset(x + length, y),
        Offset(x + length, y + length),
        paint,
      );
    }

    if (bottom) {
      canvas.drawLine(
        Offset(x + length, y + length),
        Offset(x, y + length),
        paint,
      );
    }

    if (left) {
      canvas.drawLine(Offset(x, y + length), Offset(x, y), paint);
    }

    if (visited) {
      canvas.drawRect(
        Rect.fromLTWH(x, y, length, length),
        paint
          ..color = Colors.grey[700].withOpacity(.5)
          ..style = PaintingStyle.fill,
      );
    }
  }

  Cell checkNeighbors(
    List<Cell> grid, {
    @required int rows,
    @required int columns,
  }) {
    final neighbors = <Cell>[];

    final topIndex = index(i - 1, j, rows, columns);
    final rightIndex = index(i, j + 1, rows, columns);
    final bottomIndex = index(i + 1, j, rows, columns);
    final leftIndex = index(i, j - 1, rows, columns);

    final topCell = topIndex != -1 ? grid[topIndex] : null;
    final rightCell = rightIndex != -1 ? grid[rightIndex] : null;
    final bottomCell = bottomIndex != -1 ? grid[bottomIndex] : null;
    final leftCell = leftIndex != -1 ? grid[leftIndex] : null;

    if (topCell != null && !topCell.visited) {
      neighbors.add(topCell);
    }
    if (rightCell != null && !rightCell.visited) {
      neighbors.add(rightCell);
    }
    if (bottomCell != null && !bottomCell.visited) {
      neighbors.add(bottomCell);
    }
    if (leftCell != null && !leftCell.visited) {
      neighbors.add(leftCell);
    }

    if (neighbors.isNotEmpty) {
      final randomIndex = random.nextInt(neighbors.length);
      return neighbors[randomIndex];
    }

    return null;
  }

  int index(int i, int j, int rows, int columns) {
    if (i < 0 || j < 0 || i > rows - 1 || j > columns - 1) {
      return -1;
    }

    return j + i * rows;
    // return i + j * rows;
  }

  void highlight(Canvas canvas, Size size, Paint paint) {
    final x = i * length;
    final y = j * length;

    canvas.drawRect(
      Rect.fromLTWH(x, y, length, length),
      paint
        ..color = Colors.blue.withOpacity(.5)
        ..style = PaintingStyle.fill,
    );
  }
}
