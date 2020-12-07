import 'dart:math';
import 'dart:ui' as UI;

import 'package:challenges/game_state.dart';
import 'package:challenges/pages/snake_game/models/food.dart';
import 'package:challenges/pages/snake_game/models/snake.dart';
import 'package:challenges/pages/snake_game/models/snake_game_state.dart';
import 'package:challenges/utils/load_ui_image.dart';
import 'package:flutter/material.dart';

class SnakeGame extends StatefulWidget {
  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  final snakeGameState = SnakeGameState(GameState.menu);
  Future<UI.Image> _imageFuture;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(days: 365),
    );

    _animationController.forward();

    _imageFuture = loadUiImage('assets/apple.png');

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
      appBar: AppBar(title: Text('The Snake (Worm) Game')),
      body: SizedBox.expand(
        child: FutureBuilder<UI.Image>(
          future: _imageFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            if (snapshot.hasError) {
              throw snapshot.error;
            }

            return RepaintBoundary(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, __) {
                  return CustomPaint(
                    willChange: true,
                    painter: SnakeGamePainter(
                      _animationController,
                      snakeGameState,
                      snapshot.data,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class SnakeGamePainter extends CustomPainter {
  SnakeGamePainter(this.animation, this.snakeGameState, this.appleImage)
      : brush = Paint()..color = Colors.white,
        textStyle = TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
        checkBounds = true,
        snake = snakeGameState.snake,
        super(repaint: animation);

  static final dPadBottomPadding = 56.0;
  static final buttonLength = 32.0;

  final Animation<double> animation;
  final SnakeGameState snakeGameState;
  final UI.Image appleImage;
  final Snake snake;
  final Paint brush;
  final bool checkBounds;

  int score = 0;
  TextStyle textStyle;
  Size _size;
  Size _screenSize;

  @override
  void paint(Canvas canvas, Size size) {
    _size = size; // Not ideal
    _screenSize = Size(
      size.width,
      size.height - dPadBottomPadding - (buttonLength * 4),
    ); // Not ideal

    switch (snakeGameState.gameState) {
      case GameState.menu:
        _showStartScreen(canvas, size);
        break;
      case GameState.playing:
        snakeGameState.endTime = DateTime.now();
        final deltaTime = snakeGameState.endTime.difference(
          snakeGameState.startTime,
        );
        snakeGameState.startTime = snakeGameState.endTime;

        snakeGameState.deltaTimeSum += deltaTime;
        if (snakeGameState.deltaTimeSum > snakeGameState.updateRate) {
          final toRemove = <Food>[];
          for (final food in snakeGameState.foods) {
            if (snake.canEat(food.position)) {
              toRemove.add(food);
            }
          }

          if (toRemove.isNotEmpty) {
            for (final food in toRemove) {
              snakeGameState.updateRate -= const Duration(microseconds: 5000);

              snake.eat(food);
            }

            snakeGameState.foods.removeWhere((food) {
              return toRemove.contains(food);
            });

            _createFood();
          }

          snakeGameState.deltaTimeSum = Duration.zero;

          snake.update(deltaTime);

          if (snake.ateItself()) {
            snakeGameState.gameState = GameState.lost;
          }
        }

        if (checkBounds) {
          if (_lost(_screenSize)) {
            snakeGameState.gameState = GameState.lost;
          }
        } else {
          _clamp(_screenSize);
          _drawGrid(canvas, _screenSize);
        }

        _drawScreen(canvas, _screenSize);
        _drawFood(canvas, _screenSize);
        snake.show(canvas, brush, _screenSize);
        _paintScore(canvas, size);
        _drawGamePad(canvas, size);
        break;
      case GameState.lost:
        _paintLostScreen(canvas, size);
        _paintScore(canvas, size);
        break;
      case GameState.won:
        throw 'This shouldn\'t happen';
        break;
    }
  }

  @override
  bool shouldRepaint(SnakeGamePainter oldDelegate) => true;

  @override
  bool hitTest(Offset position) {
    switch (snakeGameState.gameState) {
      case GameState.menu:
        for (int i = 0; i < snakeGameState.initialFruitCount; i++) {
          _createFood();
        }
        _createSnake();
        snakeGameState.gameState = GameState.playing;
        break;
      case GameState.lost:
        snakeGameState.gameState = GameState.menu;
        break;
      case GameState.playing:
        _handleDPadInput(position);
        break;
      case GameState.won:
        throw 'This shouldn\'t happen';
        break;
    }

    return true;
  }

  void _createFood() {
    final unitHeight = _screenSize.height / snakeGameState.rows;
    final unitWidth = _screenSize.width / snakeGameState.columns;

    snakeGameState.foods.add(
      Food(
        _pickRandomLocation(
          width: unitWidth,
          height: unitHeight,
          columns: snakeGameState.columns,
          rows: snakeGameState.rows,
        ),
        appleImage,
        width: unitWidth,
        height: unitHeight,
      ),
    );
  }

  void _createSnake() {
    final unitHeight = _screenSize.height / snakeGameState.rows;
    final unitWidth = _screenSize.width / snakeGameState.columns;
    final speed = Offset(0, -1);

    snakeGameState.snake = Snake(
      _pickRandomLocation(
        width: unitWidth,
        height: unitHeight,
        columns: snakeGameState.columns,
        rows: snakeGameState.rows,
        inMiddle: true,
      ),
      speed,
      width: unitWidth,
      height: unitHeight,
    );
  }

  void _drawFood(Canvas canvas, Size size) {
    for (final food in snakeGameState.foods) {
      food.show(canvas, size, brush);
    }
  }

  void _drawScreen(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      brush..color = Colors.grey[800],
    );
  }

  void _drawGrid(Canvas canvas, Size size) {
    for (int i = 1; i <= snakeGameState.rows - 1; i++) {
      final height = size.height * (i / snakeGameState.rows);
      canvas.drawLine(Offset(0, height), Offset(size.width, height), brush);
    }
    for (int j = 1; j <= snakeGameState.columns - 1; j++) {
      final width = size.width * (j / snakeGameState.columns);
      canvas.drawLine(Offset(width, 0), Offset(width, size.height), brush);
    }
  }

  /// Checks the bound to see if the snake has gone off the screen
  bool _lost(Size size) {
    if (snake.head.dx + (snake.width / 2) <= 0 ||
        snake.head.dx + (snake.width / 2) >= size.width) {
      return true;
    }

    if (snake.head.dy + (snake.height / 2) <= 0 ||
        snake.head.dy + (snake.height / 2) >= size.height) {
      return true;
    }

    return false;
  }

  void _clamp(Size size) {
    snake.head = Offset(
      snake.head.dx.clamp(0.0, size.width - snake.width),
      snake.head.dy.clamp(0.0, size.height - snake.height),
    );
  }

  void _paintLostScreen(Canvas canvas, Size size) {
    final textSpan = TextSpan(
      text: 'You lost!\nTap to play again.',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final offset = Offset(
      (size.width / 2) - (textPainter.size.width / 2),
      (size.height / 2) - (textPainter.size.height / 2),
    );
    textPainter.paint(canvas, offset);
  }

  void _handleDPadInput(Offset position) {
    final bottomCenter = Offset(
      _size.width / 2,
      _size.height - dPadBottomPadding,
    );
    final rightCenter = Offset(
      _size.width / 2 + (buttonLength * 1.5),
      _size.height - dPadBottomPadding - (buttonLength * 1.5),
    );
    final topCenter = Offset(
      _size.width / 2,
      _size.height - dPadBottomPadding - (buttonLength * 3),
    );
    final leftCenter = Offset(
      _size.width / 2 - (buttonLength * 1.5),
      _size.height - dPadBottomPadding - (buttonLength * 1.5),
    );

    if ((bottomCenter - position).distance <= buttonLength) {
      // Down
      snake.direction = Offset(0, 1);
    }
    if ((rightCenter - position).distance <= buttonLength) {
      // Right
      snake.direction = Offset(1, 0);
    }
    if ((topCenter - position).distance <= buttonLength) {
      // Up
      snake.direction = Offset(0, -1);
    }
    if ((leftCenter - position).distance <= buttonLength) {
      // Left
      snake.direction = Offset(-1, 0);
    }
  }

  void _showStartScreen(Canvas canvas, Size size) {
    final textSpan = TextSpan(
      text: 'Press the screen to start',
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
    final offset = Offset(
      (size.width / 2) - (textPainter.size.width / 2),
      (size.height / 2) - (textPainter.size.height / 2),
    );
    textPainter.paint(canvas, offset);
  }

  void _drawGamePad(Canvas canvas, Size size) {
    final bottom = size.height - dPadBottomPadding;

    final path = Path()
      ..moveTo((size.width / 2) - (buttonLength / 2), bottom)
      ..relativeLineTo(buttonLength, 0) // right
      ..relativeLineTo(0, -buttonLength) // up
      ..relativeLineTo(buttonLength, 0) // right
      ..relativeLineTo(0, -buttonLength) // up
      ..relativeLineTo(-buttonLength, 0) // left
      ..relativeLineTo(0, -buttonLength) // up
      ..relativeLineTo(-buttonLength, 0) // left
      ..relativeLineTo(0, buttonLength) // down
      ..relativeLineTo(-buttonLength, 0) // left
      ..relativeLineTo(0, buttonLength) // down
      ..relativeLineTo(buttonLength, 0) // right
      ..close();

    canvas.drawPath(path, brush..color = Colors.grey);
  }

  void _paintScore(Canvas canvas, Size size) {
    final textSpan = TextSpan(
      text: 'Score: ${snake.tail.length}',
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

  Offset _pickRandomLocation({
    @required double width,
    @required double height,
    @required int columns,
    @required int rows,
    bool inMiddle = false,
  }) {
    final random = Random();
    final position = Offset(
      inMiddle
          ? (random.nextInt(columns ~/ 3) + columns ~/ 3) * width
          : random.nextInt(columns) * width,
      inMiddle
          ? (random.nextInt(rows ~/ 3) + rows ~/ 3) * height
          : random.nextInt(rows) * height,
    );

    return position;
  }
}
