
import 'package:flutter/material.dart';
import 'package:algo_io_files/util/menu_view.dart';


class MainMenuScreen extends StatelessWidget {

  final List<String> _topics = [
    'Sorting Algorithms',
    'Time Complexities',
    'Graphs and Trees',
    'Abstract Data Structures',
    'Design Patterns',
  ];

  final String title = "Algorithms and Data Structures";

  @override
  Widget build(BuildContext context) {
    //menu view
    return MenuView(title, _topics);
  }

}