import 'package:algo_io_files/sorts/merge_sort.dart';
import 'package:algo_io_files/sorts/sort_animation.dart';
import 'package:flutter/material.dart';

class MergeSortScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SortAnimation<MergeSort>("MergeSort"));

    //pass in bubble sort class that extends a sort class with sort method.
  }
}
