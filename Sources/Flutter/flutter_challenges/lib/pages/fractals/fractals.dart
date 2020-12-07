import 'dart:math';

import 'package:challenges/pages/fractals/models/rule.dart';
import 'package:challenges/pages/fractals/models/tree.dart';
import 'package:challenges/utils/string_utils.dart';
import 'package:flutter/material.dart';

enum FractalType { simple, lSystem, space }

class Fractals extends StatefulWidget {
  @override
  _FractalsState createState() => _FractalsState();
}

class _FractalsState extends State<Fractals>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  var _length = 100.0;
  final _customPaintKey = GlobalKey();
  Animation<double> _simpleAngle;
  Animation<double> _lAngle;
  var _fractalType = FractalType.space;
  Tree _tree;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    );

    final Animation curve = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _simpleAngle = Tween(begin: pi / 4, end: pi / 3).animate(curve);
    _lAngle = Tween(begin: 25.43, end: 25.57).animate(curve);

    if (_fractalType == FractalType.space) {
      Future.delayed(Duration.zero, _createTree);
    } else {
      _animationController
        ..addStatusListener(_repeatingStatusListener)
        ..forward();
    }

    super.initState();
  }

  void _repeatingStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _animationController.reverse();
    } else if (status == AnimationStatus.dismissed) {
      _animationController..forward();
    }
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
          title: const Text('Fractal Trees'),
          elevation: 0,
          actions: <Widget>[
            DropdownButton<FractalType>(
              value: _fractalType,
              onChanged: (value) {
                setState(() => _fractalType = value);
                if (_fractalType == FractalType.simple ||
                    _fractalType == FractalType.lSystem) {
                  _animationController
                    ..duration = Duration(seconds: 6)
                    ..addStatusListener(_repeatingStatusListener)
                    ..forward();
                } else {
                  _createTree();
                  _animationController
                    ..duration = Duration(seconds: 15)
                    ..removeStatusListener(_repeatingStatusListener);
                  _animationController.reset();
                  _animationController.forward();
                }
              },
              items: FractalType.values.map(
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
        body: SizedBox.expand(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  key: _customPaintKey,
                  painter: FractalPainter(
                    length: _length,
                    animation: _simpleAngle,
                    lAngle: _lAngle.value,
                    fractalType: _fractalType,
                    tree: _tree,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  _createTree() {
    final RenderBox box = _customPaintKey.currentContext.findRenderObject();
    final width = box.size.width;
    final height = box.size.height;

    final tree = Tree(
      screenWidth: width,
      screenHeight: height,
    );

    setState(() => _tree = tree);

    _animationController
      ..duration = Duration(seconds: 15)
      ..forward();
  }
}

class FractalPainter extends CustomPainter {
  FractalPainter({
    @required this.animation,
    @required this.lAngle,
    @required this.length,
    @required this.fractalType,
    @required this.tree,
  })  : brush = Paint()
          ..color = Colors.indigo[100]
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.butt,
        super(repaint: animation);

  final Animation<double> animation;
  final double lAngle;
  final double length;
  final Paint brush;
  final FractalType fractalType;
  final Tree tree;

  final List<Rule> rules = [
    Rule('F', 'FF+[+F-F-F]-[-F+F+F]'),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    switch (fractalType) {
      case FractalType.simple:
        canvas.translate(size.width / 2, size.height * .64);
        _branch(canvas, size, length);
        break;
      case FractalType.lSystem:
        {
          var newLength = length * 0.7;
          brush..color = Colors.indigo[100].withOpacity(.5);
          canvas.translate(size.width / 2, size.height);
          final axiom = 'F';
          _turtle(canvas, size, newLength, axiom);
          var nextAxiom = _generate(axiom);
          newLength = length * 0.5;
          _turtle(canvas, size, newLength, nextAxiom);
          nextAxiom = _generate(nextAxiom);
          newLength *= 0.5;
          _turtle(canvas, size, newLength, nextAxiom);
          nextAxiom = _generate(nextAxiom);
          newLength *= 0.5;
          _turtle(canvas, size, newLength, nextAxiom);
          nextAxiom = _generate(nextAxiom);
          newLength *= 0.5;
          _turtle(canvas, size, newLength, nextAxiom);
        }
        break;
      case FractalType.space:
        tree.show(canvas, brush);
        tree.grow();
        break;
      default:
        throw 'Not implemented';
    }
  }

  @override
  bool shouldRepaint(FractalPainter oldDelegate) => true;

  String _generate(String axiom) {
    var nextSentence = '';

    for (int i = 0; i < axiom.length; i++) {
      final current = axiom[i];
      var found = false;

      for (final rule in rules) {
        if (current == rule.a) {
          found = true;
          nextSentence += rule.b;
          break;
        }
      }

      if (!found) {
        nextSentence += current;
      }
    }

    return nextSentence;
  }

  void _turtle(Canvas canvas, Size size, double length, String axiom) {
    for (var i = 0; i < axiom.length; i++) {
      final current = axiom[i];

      if (current == 'F') {
        canvas.drawLine(Offset(0, 0), Offset(0, -length), brush);
        canvas.translate(0, -length);
      } else if (current == '+') {
        canvas.rotate(lAngle);
      } else if (current == '-') {
        canvas.rotate(-lAngle);
      } else if (current == '[') {
        canvas.save();
      } else if (current == ']') {
        canvas.restore();
      }
    }
  }

  void _branch(Canvas canvas, Size size, double length) {
    canvas.drawLine(
      Offset(0, 0),
      Offset(0, -length),
      brush,
    );
    canvas.translate(0, -length);
    if (length > 2) {
      canvas.save();
      canvas.rotate(animation.value);
      _branch(canvas, size, length * 0.67);
      canvas.restore();
      canvas.save();
      canvas.rotate(-animation.value);
      _branch(canvas, size, length * 0.67);
      canvas.restore();
    }
  }
}
