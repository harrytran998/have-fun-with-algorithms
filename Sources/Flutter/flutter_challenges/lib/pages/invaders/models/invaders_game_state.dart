import 'package:challenges/game_state.dart';

class InvadersGameState {
  InvadersGameState({
    this.gameState = GameState.menu,
    this.currentLevel = 0,
    this.speed = 1.0,
  });

  final int currentLevel;
  final double speed;
  GameState gameState;
}
