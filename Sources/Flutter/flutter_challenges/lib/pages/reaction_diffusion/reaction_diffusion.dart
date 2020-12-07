import 'dart:ui';

import 'package:flutter/material.dart';

// TODO: Await the issue on drawing pixels to buffer directly
class ReactionDiffusion extends StatefulWidget {
  @override
  ReactionDiffusionState createState() => ReactionDiffusionState();
}

class ReactionDiffusionState extends State<ReactionDiffusion>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  ReactionDiffusionPainter painter;
  final customPaintKey = GlobalKey();

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      // Large durations sometimes breaks android.
      duration: const Duration(days: 365),
    );

    Future.delayed(Duration.zero, () {
      final context = customPaintKey.currentContext;
      final RenderBox box = context.findRenderObject();

      setState(() {
        painter = ReactionDiffusionPainter(_animationController, box.size);
      });

      // _animationController.forward();
    });

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
      appBar: AppBar(title: Text('ReactionDiffusion')),
      body: SizedBox.expand(
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, __) {
              return CustomPaint(
                key: customPaintKey,
                painter: painter,
              );
            },
          ),
        ),
      ),
    );
  }
}

class ReactionDiffusionPainter extends CustomPainter {
  ReactionDiffusionPainter(this.animation, this.size)
      : brush = Paint()..strokeWidth = 1,
        cells = List.generate(size.width.toInt(), (i) {
          return List.generate(size.height.toInt(), (j) {
            return Cell(a: 0, b: 0, offset: Offset(i.toDouble(), j.toDouble()));
          });
        }),
        next = List.generate(size.width.toInt(), (i) {
          return List.generate(size.height.toInt(), (j) {
            return Cell(a: 0, b: 0, offset: Offset(i.toDouble(), j.toDouble()));
          });
        }),
        super(repaint: animation);

  final Animation<double> animation;
  final Size size;
  final Paint brush;
  final List<List<Cell>> cells;
  final List<List<Cell>> next;

  @override
  void paint(Canvas canvas, Size size) {
    final positions =
        cells.expand((cell) => cell).map((cell) => cell.offset).toList();
    final colors = positions.map<Color>((position) => Colors.red).toList();

    for (int i = 0; i < cells.length; i++) {
      // rows
      for (int j = 0; i < cells[i].length; j++) {
        // columns

      }
    }

    // canvas.drawVertices();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class Cell {
  const Cell({
    @required this.a,
    @required this.b,
    @required this.offset,
  });

  final double a;
  final double b;
  final Offset offset;
}
