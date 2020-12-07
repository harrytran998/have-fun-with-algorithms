import 'dart:math';
import 'dart:ui';

import 'package:challenges/mixins/setup_mixin.dart';
import 'package:challenges/pages/starfield/models/star.dart';
import 'package:challenges/utils/map_range.dart';
import 'package:flutter/material.dart';

class Starfield extends StatefulWidget {
  @override
  _StarfieldState createState() => _StarfieldState();
}

class _StarfieldState extends State<Starfield>
    with SingleTickerProviderStateMixin, SetupMixin {
  AnimationController _animationController;
  final List<Star> _stars = [];

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
            builder: (context, __) {
              return CustomPaint(
                key: customPaintKey,
                willChange: true,
                painter: StarfieldPainter(
                  _animationController,
                  _stars,
                ),
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
      _stars.addAll(List.generate(400, (_) {
        final position = Offset(
          mapRange(random.nextDouble(), 0, 1, -size.width, size.width),
          mapRange(random.nextDouble(), 0, 1, -size.height, size.height),
        );
        final z = mapRange(random.nextDouble(), 0, 1, 1, size.width);

        return Star(position, z);
      }));
    });
  }

  @override
  void onWindowResize(Size size) {}
}

class StarfieldPainter extends CustomPainter {
  StarfieldPainter(this.animation, this.stars)
      : brush = Paint()..color = Colors.white.withOpacity(.5),
        textStyle = TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
        super(repaint: animation);

  final List<Star> stars;
  final Animation<double> animation;
  final Paint brush;
  TextStyle textStyle;

  @override
  void paint(Canvas canvas, Size size) {
    // Move origin to center
    canvas.translate(size.width / 2, size.height / 2);

    for (final star in stars) {
      star.show(canvas, brush, size);
      star.update(size);
    }
  }

  @override
  bool shouldRepaint(StarfieldPainter oldDelegate) => true;
}
