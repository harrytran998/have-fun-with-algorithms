import 'dart:math';
import 'dart:ui';

import 'package:challenges/mixins/setup_mixin.dart';
import 'package:challenges/pages/bubbles/models/bubble.dart';
import 'package:challenges/utils/map_range.dart';
import 'package:flutter/material.dart';

class Bubbles extends StatefulWidget {
  @override
  _BubblesState createState() => _BubblesState();
}

class _BubblesState extends State<Bubbles>
    with SingleTickerProviderStateMixin, SetupMixin {
  AnimationController _animationController;
  final List<Bubble> _bubbles = [];

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SizedBox.expand(
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _animationController,
            child: Center(
              child: Text(
                'Bubbles',
                style: Theme.of(context).textTheme.headline3.copyWith(
                      fontSize: 66.0,
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            builder: (context, widget) {
              return CustomPaint(
                key: customPaintKey,
                willChange: true,
                painter: BubblesPainter(
                  _animationController,
                  _bubbles,
                ),
                child: widget,
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void setup(Size size) {
    final random = Random();

    setState(() {
      _bubbles.addAll(List.generate(200, (_) {
        final position = Offset(
          mapRange(random.nextDouble(), 0, 1, -size.width, size.width),
          mapRange(random.nextDouble(), 0, 1, -size.height, size.height),
        );

        final radius = random.nextDouble() * 60.0;

        return Bubble(position, radius);
      }));
    });
  }

  @override
  void onWindowResize(Size size) {}
}

class BubblesPainter extends CustomPainter {
  BubblesPainter(this.animation, this.bubbles)
      : brush = Paint()..color = Colors.white.withOpacity(.5),
        _startTime = DateTime.now(),
        textStyle = TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
        super(repaint: animation);

  final List<Bubble> bubbles;
  final Animation<double> animation;
  final Paint brush;
  DateTime _startTime;
  DateTime _endTime;
  TextStyle textStyle;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    _endTime = DateTime.now();
    final deltaTime = _endTime.difference(_startTime).inMicroseconds;
    _startTime = _endTime;

    for (final bubble in bubbles) {
      bubble.show(canvas, brush, size);
      bubble.update(deltaTime, size);
    }
  }

  @override
  bool shouldRepaint(BubblesPainter oldDelegate) => true;
}
