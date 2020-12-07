import 'package:challenges/pages/invaders/models/flower.dart';

const List<Level> levels = [
  Level([
    [null, null, null, null, null, null],
    [null, Fl.e, null, null, Fl.e, null],
    [null, null, Fl.e, Fl.e, null, null],
  ], 0.1),
  Level([
    [null, null, Fl.e, Fl.e, null, null],
    [null, Fl.e, null, null, Fl.e, null],
    [null, null, Fl.e, Fl.e, null, null],
  ], 0.1),
  Level([
    [Fl.e, null, Fl.e, Fl.e, null, Fl.e],
    [null, Fl.m, null, null, Fl.m, null],
    [null, null, null, null, null, null],
  ], 0.1),
];

class Level {
  const Level(this.arrangement, this.speed) : gap = 20.0;

  final List<List<Fl>> arrangement;

  int get columns => arrangement.first.length;
  int get rows => arrangement.length;

  final double speed;
  final double gap;
}
