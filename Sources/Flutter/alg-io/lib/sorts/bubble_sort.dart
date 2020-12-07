import 'package:algo_io_files/sorts/base_sort.dart';

class BubbleSort extends BaseSort {
  @override
  void sort() async {
    for (var i = 0; i < numbers.length; i++) {
      for (var j = 0; j < numbers.length - i - 1; j++) {
        if (numbers[j].value > numbers[j + 1].value) {
          swap(j, j + 1, numbers);

          render();
          await pause();
        }
      }
    }
  }
}
