import 'package:algo_io_files/alg_io_library.dart';
import 'package:algo_io_files/sorts/base_sort.dart';

class QuickSort extends BaseSort {
  @override
  void sort() {
    quickSort(numbers, 0, numbers.length - 1);
  }

  void quickSort(List<SortModel> numbers, int leftIndex, int rightIndex) async {
    int i = leftIndex;
    int j = rightIndex;
    int pivotIndex = numbers[(leftIndex + rightIndex) ~/ 2].value;

    while (i <= j) {
      while (numbers[i].value < pivotIndex) {
        i++;
      }

      while (numbers[j].value > pivotIndex) {
        j--;
      }

      if (i <= j) {
        SortModel tmp = numbers[i];
        numbers[i] = numbers[j];
        numbers[j] = tmp;
        i++;
        j--;
        render();
        await pause();
      }
    }

    if (leftIndex < j) {
      quickSort(numbers, leftIndex, j);
    }
    if (i < rightIndex) {
      quickSort(numbers, i, rightIndex);
    }
  }
}
