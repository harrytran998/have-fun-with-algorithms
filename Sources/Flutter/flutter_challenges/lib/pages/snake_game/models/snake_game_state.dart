import 'package:challenges/game_state.dart';
import 'package:challenges/pages/snake_game/models/food.dart';
import 'package:challenges/pages/snake_game/models/snake.dart';

/// The snake by of size 1x1 when the game begins.
/// The actual dimensions will be determined by the screen size.
/// e.g., the width will be (1 / 50) * size.width
class SnakeGameState {
  SnakeGameState(
    this.gameState, {
    this.columns = 20,
    this.rows = 20,
    this.initialFruitCount = 10,
  })  : updateRate = Duration(microseconds: 333333),
        // Technically 33333 microseconds is 1 / 30 a second,
        // but that isn't working for me.
        startTime = DateTime.now();

  Snake snake;
  Duration updateRate;

  final int columns;
  final int rows;
  final List<Food> foods = [];
  final int initialFruitCount;

  Duration deltaTimeSum = Duration.zero;
  DateTime startTime;
  DateTime endTime;

  GameState gameState;
}
