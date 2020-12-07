import 'package:challenges/mixins/setup_mixin.dart';
import 'package:flutter/material.dart';

class ColorInterpolation extends StatefulWidget {
  @override
  _ColorInterpolationState createState() => _ColorInterpolationState();
}

class _ColorInterpolationState extends State<ColorInterpolation>
    with SingleTickerProviderStateMixin, SetupMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    // _animationController
    //   ..addListener(() {
    //     // debugPrint('${_animationController.value}');
    //     print(_animationController.value);
    //   })
    //   ..forward();

    // _animationController.forward();
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
      appBar: AppBar(title: Text('ColorInterpolation')),
      body: SizedBox.expand(
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, __) {
              return CustomPaint(
                key: customPaintKey,
                painter: ColorInterpolationPainter(_animationController),
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
  void setup(Size size) {}
}

class ColorInterpolationPainter extends CustomPainter {
  const ColorInterpolationPainter(this.animation) : super(repaint: animation);

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    // Paints whole canvas this doesn't work.
    // You have to break up the canvas first
    // for (int i = 0; i < size.height; i++) {
    //   for (int j = 0; j < size.width; i++) {
    //     canvas.drawColor(Colors.blue, BlendMode.color);
    //   }
    // }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
