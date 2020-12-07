import 'dart:ui';

import 'package:challenges/game_state.dart';
import 'package:flutter/material.dart';

class GameTemplate extends StatefulWidget {
  @override
  GameTemplateState createState() => GameTemplateState();
}

class GameTemplateState extends State<GameTemplate>
    with SingleTickerProviderStateMixin {
  GameTemplatePainter painter;
  AnimationController _animationController;
  final customPaintKey = GlobalKey();

  var gameState = GameState.menu;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        days: 365, // Large durations sometimes breaks android.
      ),
    );

    Future.delayed(Duration.zero, () {
      final context = customPaintKey.currentContext;
      final RenderBox box = context.findRenderObject();

      setState(() {
        painter = GameTemplatePainter(_animationController, box.size);
      });

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
      appBar: AppBar(title: Text('GameTemplate')),
      body: SizedBox.expand(
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, __) {
              return CustomPaint(
                key: customPaintKey,
                willChange: true,
                painter: painter,
              );
            },
          ),
        ),
      ),
    );
  }
}

class GameTemplatePainter extends CustomPainter {
  GameTemplatePainter(this.animation, this.size)
      : brush = Paint(),
        _startTime = DateTime.now(),
        textStyle = TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
        super(repaint: animation);

  final Animation<double> animation;
  final Paint brush;
  final Size size;

  DateTime _startTime;
  DateTime _endTime;
  TextStyle textStyle;
  GameTemplateState state;

  @override
  void paint(Canvas canvas, Size size) {
    _endTime = DateTime.now();
    final deltaTime = _endTime.difference(_startTime);
    _startTime = _endTime;

    switch (state.gameState) {
      case GameState.menu:
        break;
      case GameState.playing:
        break;
      case GameState.lost:
        break;
      case GameState.won:
        break;
    }

    final textSpan = TextSpan(
      text: 'Delta Time (μ): ${deltaTime.inMicroseconds}',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final offset = Offset(size.width - textPainter.size.width - 16.0, 16.0);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(GameTemplatePainter oldDelegate) => false;
}
