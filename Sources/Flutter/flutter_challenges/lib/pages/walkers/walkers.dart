import 'package:challenges/pages/walkers/models/branch.dart';
import 'package:challenges/utils/string_utils.dart';
import 'package:flutter/material.dart';

enum StepFunction { straight, random, noise, perlin }

class Walkers extends StatefulWidget {
  @override
  _WalkersState createState() => _WalkersState();
}

class _WalkersState extends State<Walkers> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  final _customPaintKey = GlobalKey();
  var _stepFunction = StepFunction.straight;

  var _branches = <Branch>[];

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Random Walkers'),
          elevation: 0,
          actions: <Widget>[
            DropdownButton<StepFunction>(
              value: _stepFunction,
              onChanged: (value) => setState(() => _stepFunction = value),
              items: StepFunction.values.map(
                (value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(capitalize(value.toString().split('.')[1])),
                  );
                },
              ).toList(),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: _paint,
        ),
        body: SizedBox.expand(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  key: _customPaintKey,
                  painter: WalkerPaint(
                    _branches,
                    _animationController,
                    _stepFunction,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  _paint() {
    Branch.colors.clear();
    Branch.colors.add(Color.fromARGB(50, 0, 255, 255));
    _animationController.reset();

    final branches = _createBranches(50);

    setState(() => _branches = branches);
    _animationController.forward();
  }

  List<Branch> _createBranches(int amount) {
    final RenderBox box = _customPaintKey.currentContext.findRenderObject();

    final branches = <Branch>[];
    final width = box.size.width;
    final height = box.size.height;

    for (var i = 0; i < amount; i++) {
      final x = width / 2;
      final y = height / 2;

      branches.add(Branch(initialOffset: Offset(x, y)));
    }

    return branches;
  }
}

class WalkerPaint extends CustomPainter {
  WalkerPaint(
    this.branches,
    this.animation,
    this.stepFunction,
  )   : brush = Paint()
          ..color = Colors.blue
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.butt,
        super(repaint: animation);

  final List<Branch> branches;
  final Animation<double> animation;
  final StepFunction stepFunction;
  final Paint brush;

  @override
  void paint(Canvas canvas, Size size) {
    final color = Color.fromARGB(
      100,
      (((animation.value * 720) % 100) + 155).toInt(),
      (((animation.value * 255) % 100) + 155).toInt(),
      200,
    );
    Branch.colors.add(color);

    for (final branch in branches) {
      if (branch.visible) {
        switch (stepFunction) {
          case StepFunction.straight:
            branch.moveStraight();
            break;
          case StepFunction.random:
            branch.moveRandom();
            break;
          case StepFunction.noise:
            branch.moveNoise(animation.value);
            break;
          case StepFunction.perlin:
            branch.movePerlin(animation.value);
            break;
          default:
        }
      }

      branch.draw(canvas, brush);
      branch.walls(size);
    }
  }

  @override
  bool shouldRepaint(WalkerPaint oldDelegate) => true;
}
