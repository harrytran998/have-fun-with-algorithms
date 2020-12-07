import 'dart:math';

import 'package:algo_io_files/alg_io_library.dart';

import 'package:flutter/material.dart';

abstract class BaseSort extends ChangeNotifier {

  static int numModels = 10;

  Random rng = new Random();
  List<SortModel> numbers = new List();

  BaseSort() {
    genNumbers();
  }

  void reset()  {
    for (int i = 0; i < numModels; i++) {
      numbers[i].value = rng.nextInt(10);
    }
    notifyListeners();

  }

  void genNumbers() {

    for (int i = 0; i < numModels; i++) {
      numbers.add(SortModel(rng.nextInt(numModels)));
    }

  }

  void sort();

  void swap(int i, int j, List<SortModel> numbers) {
    SortModel tmp = numbers[i];
    numbers[i] = numbers[j];
    numbers[j] = tmp;
  }

  Future pause() async {
    var executionSpeed = 600;
    await Future.delayed(Duration(milliseconds: executionSpeed));
  }

  void render() {
    notifyListeners();
  }

  List<SortModel> getNumbers() {
    return numbers;
  }

  static int getNumModels() {
    return numModels;
  }
}
