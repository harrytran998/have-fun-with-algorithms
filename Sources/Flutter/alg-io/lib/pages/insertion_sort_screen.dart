import 'package:algo_io_files/sorts/insertion_sort.dart';
import 'package:algo_io_files/sorts/sort_animation.dart';
import 'package:flutter/material.dart';

class InsertionSortScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SortAnimation<InsertionSort>("Insertion Sort"));

    //pass in bubble sort class that extends a sort class with sort method.
  }
}
