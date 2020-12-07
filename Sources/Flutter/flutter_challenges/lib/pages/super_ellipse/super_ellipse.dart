import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuperEllipse extends StatefulWidget {
  @override
  SuperEllipseState createState() => SuperEllipseState();
}

class SuperEllipseState extends State<SuperEllipse>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  SuperEllipsePainter painter;
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

      painter = SuperEllipsePainter(_animationController, box.size, Random());
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
      appBar: AppBar(title: const Text('Super Ellipse')),
      body: SizedBox.expand(
        child: RepaintBoundary(
          child: AnimatedBuilder(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 140.0),
                  child: Center(
                    child: Text(
                      'City Hitch',
                      style: GoogleFonts.mavenPro().copyWith(
                        fontSize: 76.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                IntrinsicHeight(
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: <Widget>[
                      Image.network(
                        'https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fwww.clker.com%2Fcliparts%2Fe%2F7%2F2%2F1%2F1317788420400831019pittsburgh%2520skyline%2520silhouette%2520600dpi-hi.png&f=1&nofb=1',
                        fit: BoxFit.fitHeight,
                        width: double.infinity,
                        height: 400,
                      ),
                      Center(
                        child: ClipOval(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Colors.purple,
                                  Colors.purpleAccent
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              iconSize: 58.0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              icon: Icon(Icons.compare_arrows),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                key: customPaintKey,
                painter: painter,
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }
}

class SuperEllipsePainter extends CustomPainter {
  SuperEllipsePainter(this.animation, this.size, this.random)
      : stars = List.generate(800, (index) {
          final r = size.height * sqrt(random.nextDouble());
          final theta = random.nextDouble() * 2 * pi;
          final x = (size.width / 2) + r * cos(theta);
          final y = size.height + r * sin(theta);
          final position = Offset(x, y);
          final radius = random.nextDouble() * 12 + 2;

          return Star(position, radius);
        }),
        super(repaint: animation);

  final Animation<double> animation;
  final Random random;
  final Size size;
  final List<Star> stars;

  var n = .3;
  var rotation = 0.0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height);
    canvas.rotate(rotation);
    rotation += 0.003;

    canvas.translate(-size.width / 2, -size.height);
    for (final star in stars) {
      star.draw(canvas, size, n);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class Star {
  const Star(this.position, this.radius);

  final Offset position;
  final double radius;

  draw(Canvas canvas, Size size, double n) {
    final points = <Offset>[];
    canvas.save();

    canvas.translate(position.dx, position.dy);

    for (var angle = 0.0; angle < pi * 2; angle += 0.1) {
      final na = 2 / n;
      final x = pow(cos(angle).abs(), na) * radius * cos(angle).sign;
      final y = pow(sin(angle).abs(), na) * radius * sin(angle).sign;

      points.add(Offset(x, y));
    }

    canvas.drawPath(
      Path()..addPolygon(points, true),
      Paint()..color = Colors.white,
    );

    canvas.restore();
  }
}
