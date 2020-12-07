import 'package:algo_io_files/util/menu_view.dart';
import 'package:flutter/material.dart';

class SortingAlgScreen extends StatelessWidget {
  final List<String> _topics = [
    'Bubble Sort',
    'Insertion Sort',
    'Quick Sort',
    'Merge Sort'
  ];

  final String _title = "Sorting Algorithms";

  @override
  Widget build(BuildContext context) {
    return MenuView(_title, _topics);
  }
}
