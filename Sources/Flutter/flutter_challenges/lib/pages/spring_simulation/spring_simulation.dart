import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class SpringSimulation extends StatefulWidget {
  @override
  SpringSimulationState createState() => SpringSimulationState();
}

class SpringSimulationState extends State<SpringSimulation>
    with SingleTickerProviderStateMixin {
  final customPaintKey = GlobalKey();

  AnimationController _animationController;
  SpringSimulationPainter painter;

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

      painter = SpringSimulationPainter(_animationController, box.size);
      // setState(() {});

      _animationController.forward();
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
      appBar: AppBar(title: Text('SpringSimulation')),
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

class SpringSimulationPainter extends CustomPainter {
  SpringSimulationPainter(this.animation, this.size)
      : startTime = DateTime.now(),
        super(repaint: animation) {
    simulation = GravitySimulation(
      10.0, // acceleration, pixels per second per second
      0.0, // starting position, pixels
      size.height, // ending position, pixels
      1.0, // starting velocity, pixels per second
    );
  }

  final Animation<double> animation;
  final Size size;
  DateTime startTime;
  DateTime endTime;
  Duration runningTime = Duration.zero;
  Simulation simulation;

  @override
  void paint(Canvas canvas, Size size) {
    endTime = DateTime.now();
    final deltaTime = endTime.difference(startTime);
    startTime = endTime;
    runningTime += deltaTime;

    final position = simulation.dx(runningTime.inMicroseconds / 1000000);

    canvas.drawCircle(
      Offset(size.width / 2, position),
      10.0,
      Paint()..color = Colors.red,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
