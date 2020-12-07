import 'package:algo_io_files/pages/insertion_sort_screen.dart';
import 'package:algo_io_files/pages/merge_sort_screen.dart';
import 'package:algo_io_files/pages/quick_sort_screen.dart';
import 'package:algo_io_files/sorts/bubble_sort.dart';
import 'package:algo_io_files/sorts/insertion_sort.dart';
import 'package:algo_io_files/sorts/merge_sort.dart';
import 'package:algo_io_files/sorts/quick_sort.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'alg_io_library.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => new BubbleSort()),
      ChangeNotifierProvider(create: (context) => new InsertionSort()),
      ChangeNotifierProvider(create: (context) => new QuickSort()),
      ChangeNotifierProvider(create: (context) => new MergeSort()),
    ],
    child: AlgIO(),
  ));
}

class AlgIO extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        backgroundColor: Color.fromARGB(100, 56, 99, 168),
        primaryColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.5),
          size: 20,
        ),
        textTheme: TextTheme(
          headline1: GoogleFonts.ubuntu(
            textStyle: Theme.of(context).textTheme.headline1,
            fontSize: 100,
            color: Colors.white,
          ),
          headline2: GoogleFonts.ubuntu(
            textStyle: Theme.of(context).textTheme.headline1,
            fontSize: 22,
            color: Colors.white,
          ),
          bodyText1: GoogleFonts.ubuntu(
            textStyle: Theme.of(context).textTheme.bodyText1,
            fontSize: 20,
            color: Colors.white,
          ),
          bodyText2: GoogleFonts.ubuntu(
            textStyle: Theme.of(context).textTheme.bodyText2,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      routes: {
        '/': (context) => WelcomeScreen(),
        '/home': (context) => MainMenuScreen(),
        '/home/Sorting Algorithms': (context) => SortingAlgScreen(),
        '/home/Sorting Algorithms/Bubble Sort': (context) => BubbleSortScreen(),
        '/home/Sorting Algorithms/Insertion Sort': (context) => InsertionSortScreen(),
        '/home/Sorting Algorithms/Quick Sort': (context) => QuickSortScreen(),
        '/home/Sorting Algorithms/Merge Sort': (context) => MergeSortScreen(),
      },
    );
  }
}
