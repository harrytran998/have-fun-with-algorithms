import 'dart:math';

import 'package:challenges/mixins/setup_mixin.dart';
import 'package:challenges/pages/solar_system/models/sun.dart';
import 'package:flutter/material.dart';

class SolarSystem extends StatefulWidget {
  @override
  _SolarSystemState createState() => _SolarSystemState();
}

class _SolarSystemState extends State<SolarSystem>
    with SingleTickerProviderStateMixin, SetupMixin {
  AnimationController _animationController;
  Sun sun;
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
      appBar: AppBar(title: const Text('SolarSystem')),
      body: SizedBox.expand(
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, __) {
              return CustomPaint(
                key: customPaintKey,
                painter: isInitialized
                    ? SolarSystemPainter(
                        _animationController,
                        sun,
                      )
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
    sun = Sun(random: Random(), showMoons: true);

    setState(() => isInitialized = true);
  }
}

class SolarSystemPainter extends CustomPainter {
  SolarSystemPainter(this.animation, this.sun)
      : brush = Paint()..color = Colors.white,
        super(repaint: animation);

  final Animation<double> animation;
  final Sun sun;

  final Paint brush;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    sun.show(canvas, size, brush);

    for (final planet in sun.planets) {
      planet.show(canvas, size, brush);
      planet.orbit();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
