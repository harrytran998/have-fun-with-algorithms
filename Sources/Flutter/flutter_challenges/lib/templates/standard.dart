import 'package:flutter/material.dart';

class Standard extends StatefulWidget {
  @override
  StandardState createState() => StandardState();
}

class StandardState extends State<Standard>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  StandardPainter painter;
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

      setState(() => painter = StandardPainter(_animationController, box.size));

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
      appBar: AppBar(title: Text('Standard')),
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

class StandardPainter extends CustomPainter {
  const StandardPainter(this.animation, this.size) : super(repaint: animation);

  final Animation<double> animation;
  final Size size;

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
