import 'dart:ui';
import 'dart:ui' as UI;

import 'package:challenges/game_state.dart';
import 'package:challenges/mixins/setup_mixin.dart';
import 'package:challenges/pages/invaders/levels.dart';
import 'package:challenges/pages/invaders/models/flower.dart';
import 'package:challenges/pages/invaders/models/invaders_game_state.dart';
import 'package:challenges/pages/invaders/models/water_drop.dart';
import 'package:challenges/pages/invaders/models/watering_can.dart';
import 'package:challenges/utils/load_ui_image.dart';
import 'package:flutter/material.dart';

class Invaders extends StatefulWidget {
  @override
  _InvadersState createState() => _InvadersState();
}

class _InvadersState extends State<Invaders>
    with SingleTickerProviderStateMixin, SetupMixin {
  bool isInitialized = false;
  AnimationController _animationController;
  List<Flower> flowers = [];
  List<WaterDrop> waterDrops = [];
  WateringCan wateringCan;
  UI.Image waterDropImage;
  UI.Image wateringCanImage;
  List<UI.Image> flowerImages;
  InvadersGameState invadersGameState;
  Size _size;

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
      appBar: AppBar(title: Text('Invaders')),
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            // Image.network(
            //   'http://clipart-library.com/images/6Tr5Ej4pc.jpg',
            //   fit: BoxFit.cover,
            // ),
            RepaintBoundary(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, __) {
                  return CustomPaint(
                    key: customPaintKey,
                    painter: isInitialized
                        ? InvadersPainter(
                            _animationController,
                            wateringCan: wateringCan,
                            flowers: flowers,
                            waterDrops: waterDrops,
                            invadersGameState: invadersGameState,
                            waterDropImage: waterDropImage,
                            reset: _reset,
                          )
                        : null,
                  );
                },
              ),
            ),
            GestureDetector(
              onPanUpdate: _startShooting,
              onPanDown: _startShooting,
              onPanEnd: (_) => _stopShooting(),
            ),
          ],
        ),
      ),
    );
  }

  void _startShooting(dynamic event) {
    switch (invadersGameState.gameState) {
      case GameState.menu:
        invadersGameState.gameState = GameState.playing;
        break;
      case GameState.playing:
        wateringCan.isShooting = true;
        wateringCan.targetPosition = event.localPosition;
        break;
      case GameState.lost:
        _reset();
        invadersGameState.gameState = GameState.menu;
        break;
      case GameState.won:
        invadersGameState.gameState = GameState.menu;
        break;
    }
  }

  void _stopShooting() {
    wateringCan.isShooting = false;
  }

  @override
  void onWindowResize(Size size) {}

  @override
  void setup(Size size) async {
    _size = size;
    await _fetchImages();

    _reset();

    setState(() => isInitialized = true);
  }

  void _reset([int currentLevel = 0]) {
    waterDrops.clear();
    flowers.clear();

    final position = Offset(_size.width / 2, _size.height - 100);
    wateringCan = WateringCan(position, image: wateringCanImage);

    final flowerSize = 30.0;
    final level = levels[currentLevel];

    invadersGameState = InvadersGameState(
      currentLevel: currentLevel,
      gameState: GameState.playing,
    );

    for (int i = 0; i < level.rows; i++) {
      for (int j = 0; j < level.columns; j++) {
        final flowerLevel = level.arrangement[i][j];
        if (flowerLevel == null) continue;
        UI.Image image;

        switch (flowerLevel) {
          case Fl.e:
            image = flowerImages[0];
            break;
          case Fl.m:
            image = flowerImages[1];
            break;
          case Fl.h:
            image = flowerImages[2];
            break;
        }

        final position = Offset(
          30.0 + (j * (level.gap + flowerSize)),
          100.0 + (i * 100),
        );

        flowers.add(Flower(
          position,
          flowerSize,
          image,
          flowerLevel,
        ));
      }
    }
  }

  Future<void> _fetchImages() async {
    final images = await Future.wait([
      loadUiImage('assets/watering_can.png'),
      loadUiImage('assets/flower_1.png'),
      loadUiImage('assets/flower_2.png'),
      loadUiImage('assets/flower_3.png'),
      loadUiImage('assets/water_drop.png'),
    ]);

    wateringCanImage = images.first;
    flowerImages = images.getRange(1, 3).toList();
    waterDropImage = images[4];
  }
}

class InvadersPainter extends CustomPainter {
  InvadersPainter(
    this.animation, {
    @required this.wateringCan,
    @required this.flowers,
    @required this.waterDrops,
    @required this.invadersGameState,
    @required this.waterDropImage,
    @required this.reset,
  })  : brush = Paint()..color = Colors.white,
        _startTime = DateTime.now(),
        textStyle = TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
        super(repaint: animation);

  final Animation<double> animation;
  final Paint brush;
  final WateringCan wateringCan;
  final List<Flower> flowers;
  final List<WaterDrop> waterDrops;
  InvadersGameState invadersGameState;
  final UI.Image waterDropImage;
  void Function([int currentLevel]) reset;

  DateTime _startTime;
  DateTime _endTime;
  TextStyle textStyle;

  @override
  void paint(Canvas canvas, Size size) {
    _endTime = DateTime.now();
    final deltaTime = _endTime.difference(_startTime);
    _startTime = _endTime;

    switch (invadersGameState.gameState) {
      case GameState.menu:
        _showStartScreen(canvas, size);
        break;
      case GameState.playing:
        _gameLoop(canvas, size, deltaTime);
        break;
      case GameState.lost:
        _paintLostScreen(canvas, size);
        break;
      case GameState.won:
        _paintWonScreen(canvas, size);
        break;
    }
  }

  void _gameLoop(Canvas canvas, Size size, Duration deltaTime) {
    if (wateringCan.isShooting) {
      wateringCan.timePassed += deltaTime;

      if (wateringCan.timePassed >= wateringCan.shootingRate) {
        wateringCan.timePassed = Duration.zero;

        _shoot(wateringCan.position);
      }
    }

    wateringCan.show(canvas, size, brush);
    wateringCan.update(deltaTime);

    var hitEdge = false;

    if (flowers.isEmpty) {
      if (invadersGameState.currentLevel == levels.length - 1) {
        invadersGameState.gameState = GameState.lost;
        // TODO:
        // invadersGameState.gameState = GameState.won;
      } else {
        reset(invadersGameState.currentLevel + 1);
      }
    }

    final List<Flower> flowersToRemove = [];
    for (final flower in flowers) {
      flower.show(canvas, size, brush);
      flower.update(deltaTime);

      if (flower.hitEdge(size)) hitEdge = true;

      if (flower.hits(wateringCan) || flower.passedBottom(size)) {
        invadersGameState.gameState = GameState.lost;
      }

      if (flower.exploded) {
        flowersToRemove.add(flower);
      }
    }

    if (hitEdge) {
      for (final flower in flowers) {
        flower.velocity *= -1.0;
        flower.position = flower.position.translate(0, 40);
      }
    }

    flowers.removeWhere((flower) => flowersToRemove.contains(flower));

    final List<WaterDrop> waterDropsToRemove = [];
    assert(waterDrops.length < 100);
    for (final waterDrop in waterDrops) {
      waterDrop.show(canvas, size, brush);
      waterDrop.update(deltaTime);

      if (waterDrop.isOffScreen) {
        waterDropsToRemove.add(waterDrop);
      }

      for (final flower in flowers) {
        if (waterDrop.hits(flower)) {
          flower.grow();
          waterDropsToRemove.add(waterDrop);
        }
      }
    }

    waterDrops.removeWhere((drop) => waterDropsToRemove.contains(drop));
  }

  void _shoot(Offset position) {
    waterDrops.add(
      WaterDrop(
        position.translate(
          wateringCan.canSize / 2 - 8.0,
          -wateringCan.canSize / 2 - 6.0,
        ),
        image: waterDropImage,
      ),
    );
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

  void _paintWonScreen(Canvas canvas, Size size) {
    final textSpan = TextSpan(
      text: 'You won!\nTap to go to menu or press return to go back.',
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

  @override
  bool shouldRepaint(InvadersPainter oldDelegate) => true;
}
