import 'dart:math';

import 'package:challenges/mixins/setup_mixin.dart';
import 'package:challenges/pages/mitosis/models/cell.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

// TODO: Has an odd issue where cells will stop all of a sudden
class Mitosis extends StatefulWidget {
  @override
  _MitosisState createState() => _MitosisState();
}

class _MitosisState extends State<Mitosis>
    with SingleTickerProviderStateMixin, SetupMixin {
  AnimationController _animationController;
  final List<Cell> cells = [];
  bool isInitialized = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(days: 365),
    );

    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mitosis')),
      body: SizedBox.expand(
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, __) {
              return CustomPaint(
                key: customPaintKey,
                painter: isInitialized
                    ? MitosisPainter(_animationController, cells: cells)
                    : null,
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void onWindowResize(Size size) {}

  @override
  void setup(Size size) {
    final random = Random();
    final simplexNoise = vm.SimplexNoise();
    final cell = Cell(
      color: Color(random.nextInt(0xffffffff)),
      simplexNoise: simplexNoise,
      position: Offset(
        random.nextInt(size.width.toInt()).toDouble(),
        random.nextInt(size.height.toInt()).toDouble(),
      ),
    );

    cells.add(cell);

    setState(() => isInitialized = true);
  }
}

class MitosisPainter extends CustomPainter {
  MitosisPainter(
    this.animation, {
    this.cells,
  })  : brush = Paint()..color = Colors.white,
        super(repaint: animation);

  final Animation<double> animation;
  final List<Cell> cells;

  final Paint brush;

  @override
  void paint(Canvas canvas, Size size) {
    for (final cell in cells) {
      cell.show(canvas, size, brush);
      cell.move(size, animation.value);
    }
  }

  @override
  bool hitTest(Offset position) {
    final List<Cell> cellsToAdd = [];
    final List<Cell> cellsToRemove = [];
    for (final cell in cells) {
      if (cell.tapped(position)) {
        final newCells = cell.mitosis();
        cellsToAdd.addAll(newCells);
        cellsToRemove.add(cell);
        break;
      }
    }

    cells.addAll(cellsToAdd);
    cells.removeWhere((cell) => cellsToRemove.contains(cell));

    return super.hitTest(position);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
