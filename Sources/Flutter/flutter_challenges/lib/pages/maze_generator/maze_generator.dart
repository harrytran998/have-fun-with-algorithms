import 'dart:math';

import 'package:challenges/mixins/setup_mixin.dart';
import 'package:challenges/pages/maze_generator/models/cell.dart';
import 'package:flutter/material.dart';

class MazeGenerator extends StatefulWidget {
  @override
  MazeGeneratorState createState() => MazeGeneratorState();
}

class MazeGeneratorState extends State<MazeGenerator>
    with SingleTickerProviderStateMixin, SetupMixin {
  AnimationController _animationController;
  var isInitialized = false;
  int rows, columns;
  double length;
  Cell current;
  final grid = <Cell>[];
  final stack = <Cell>[];

  var startTime = DateTime.now();
  DateTime endTime;
  var currentSum = Duration.zero;
  final updateRate = Duration(microseconds: 48880);

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
      appBar: AppBar(title: Text('MazeGenerator')),
      body: SizedBox.expand(
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, __) {
                    return CustomPaint(
                      key: customPaintKey,
                      painter: isInitialized
                          ? MazeGeneratorPainter(
                              _animationController,
                              this,
                            )
                          : null,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onWindowResize(Size size) {}

  @override
  void setup(Size size) {
    length = 40;
    rows = (size.height / length).floor();
    columns = (size.width / length).floor();

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        final cell = Cell(i: i, j: j, length: length, random: Random());

        grid.add(cell);
      }
    }

    current = grid.first;

    setState(() => isInitialized = true);
  }
}

class MazeGeneratorPainter extends CustomPainter {
  MazeGeneratorPainter(
    this.animation,
    this.state,
  ) : super(repaint: animation);

  final Animation<double> animation;
  final MazeGeneratorState state;

  @override
  void paint(Canvas canvas, Size size) {
    final brush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    for (final cell in state.grid) {
      cell.show(canvas, size, brush..color = Colors.white);
    }

    state.current.highlight(canvas, size, brush);

    state.endTime = DateTime.now();
    final deltaTime = state.endTime.difference(state.startTime);
    state.startTime = state.endTime;

    state.currentSum += deltaTime;

    if (state.currentSum > state.updateRate) {
      state.currentSum = Duration.zero;

      state.current.visited = true;

      /// STEP 1
      final next = state.current.checkNeighbors(
        state.grid,
        rows: state.rows,
        columns: state.columns,
      );

      if (next != null) {
        next.visited = true;

        /// STEP 2
        state.stack.add(state.current);

        /// STEP 3
        _removeWalls(state.current, next);

        /// STEP 4
        state.current = next;
      } else if (state.stack.isNotEmpty) {
        state.current = state.stack.removeLast();
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  _removeWalls(Cell current, Cell next) {
    final x = current.i - next.i;
    final y = current.j - next.j;

    if (x == 1) {
      current.left = false;
      next.right = false;
    } else if (x == -1) {
      current.right = false;
      next.left = false;
    }

    if (y == 1) {
      current.top = false;
      next.bottom = false;
    } else if (y == -1) {
      current.bottom = false;
      next.top = false;
    }
  }
}
