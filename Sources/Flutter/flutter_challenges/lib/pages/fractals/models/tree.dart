import 'dart:math';

import 'package:challenges/pages/fractals/models/branch.dart';
import 'package:flutter/material.dart';

final random = Random();

class Tree {
  Tree({
    @required this.screenWidth,
    @required this.screenHeight,
  })  : leaves = List<Leaf>.generate(
          100,
          (_) => Leaf(screenWidth, screenHeight),
        ),
        root = Branch(
          null,
          Offset(screenWidth / 2, screenHeight),
          Offset(0, -1),
        ) {
    branches.add(root);

    var current = root;

    var found = false;

    while (!found) {
      for (final leaf in leaves) {
        final distance = (current.position - leaf.position).distance;
        if (distance < maxDistance) {
          found = true;
        }
      }

      if (!found) {
        current = current.next();
        branches.add(current);
      }
    }
  }

  static const maxDistance = 100;
  static const minDistance = 10;
  final double screenWidth;
  final double screenHeight;
  final List<Leaf> leaves;
  final Branch root;
  final List<Branch> branches = [];

  void show(Canvas canvas, Paint paint) {
    for (final leaf in leaves) {
      leaf.show(canvas, paint);
    }

    for (final branch in branches) {
      branch.show(canvas, paint);
    }
  }

  void grow() {
    for (final leaf in leaves) {
      Branch closestBranch;
      var recordDistance = 1000000.0;

      for (final branch in branches) {
        final distance = (leaf.position - branch.position).distance;

        if (distance < minDistance) {
          leaf.reached = true;
          break;
        } else if (distance > maxDistance) {
        } else if (closestBranch == null || distance < recordDistance) {
          closestBranch = branch;
          recordDistance = distance;
        }
      }

      if (closestBranch != null) {
        final direction = leaf.position - closestBranch.position;
        final magnitude = direction.distance;
        final normalizedDirection = direction / magnitude;

        closestBranch.direction += normalizedDirection;
        closestBranch.count++;
      }
    }

    for (int i = leaves.length - 1; i >= 0; i--) {
      final leaf = leaves[i];

      if (leaf.reached) {
        leaves.remove(leaf);
      }
    }

    for (int i = branches.length - 1; i >= 0; i--) {
      final branch = branches[i];

      if (branch.count > 0) {
        branch.direction /= (branch.count.toDouble() + 1.0);

        branches.add(branch.next());
      }

      branch.reset();
    }
  }
}

class Leaf {
  Leaf(double screenWidth, double screenHeight)
      : position = Offset(
          random.nextInt(screenWidth.toInt()).toDouble(),
          random.nextInt(screenHeight.toInt() - 120).toDouble(),
        );

  final Offset position;
  bool reached = false;

  show(Canvas canvas, Paint paint) {
    canvas.drawCircle(position, 4, paint);
  }
}
