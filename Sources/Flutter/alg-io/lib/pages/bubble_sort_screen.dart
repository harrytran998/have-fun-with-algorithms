import 'package:algo_io_files/sorts/bubble_sort.dart';
import 'package:algo_io_files/sorts/sort_animation.dart';
import 'package:flutter/material.dart';

class BubbleSortScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SortAnimation<BubbleSort>("Bubble Sort"));

    //pass in bubble sort class that extends a sort class with sort method.
  }
}
