import 'package:algo_io_files/sorts/base_sort.dart';

class InsertionSort extends BaseSort {
  @override
  void sort() async {
    var start = 0;
    var end = numbers.length;

    for (var pos = start + 1; pos < end; pos++) {
      var min = start;
      var max = pos;
      var element = numbers[pos];
      while (min < max) {
        var mid = min + ((max - min) >> 1);


        if (element.value - numbers[mid].value < 0) {
          max = mid;
        } else {
          min = mid + 1;
        }
      }
      numbers.setRange(min + 1, pos + 1, numbers, min);
      numbers[min] = element;
      render();
      await pause();
    }
  }
}
