import 'dart:math';

import 'package:challenges/mixins/setup_mixin.dart';
import 'package:challenges/pages/purple_rain/models/droplet.dart';
import 'package:flutter/material.dart';

class PurpleRain extends StatefulWidget {
  @override
  PurpleRainState createState() => PurpleRainState();
}

class PurpleRainState extends State<PurpleRain>
    with SingleTickerProviderStateMixin, SetupMixin {
  AnimationController _animationController;
  final random = Random();
  final List<Droplet> rain = [];

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
      appBar: AppBar(title: Text('Purple Rain')),
      body: SizedBox.expand(
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, __) {
              return CustomPaint(
                key: customPaintKey,
                painter: PurpleRainPainter(
                  _animationController,
                  rain,
                  random,
                ),
                willChange: true,
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
    final dropletCount = 200;

    for (int i = 0; i < dropletCount; i++) {
      final droplet = Droplet()
        ..randomPosition(size, random)
        ..randomVelocity(random);

      rain.add(droplet);
    }
  }
}

class PurpleRainPainter extends CustomPainter {
  PurpleRainPainter(this.animation, this.rain, this.random)
      : brush = Paint()..color = Colors.blue,
        super(repaint: animation);

  final Animation<double> animation;
  final List<Droplet> rain;
  final Random random;
  final Paint brush;

  @override
  void paint(Canvas canvas, Size size) {
    for (final droplet in rain) {
      droplet.show(canvas, brush);
      droplet.update(size, random);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
