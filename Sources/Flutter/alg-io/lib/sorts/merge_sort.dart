import 'dart:math';

import 'package:algo_io_files/alg_io_library.dart';
import 'package:algo_io_files/sorts/base_sort.dart';


class MergeSort extends BaseSort {
  @override
  void sort() {
// For current size of subarrays to
    // be merged curr_size varies from
    // 1 to n/2
    int currSize;

    // For picking starting index of
    // left subarray to be merged
    int leftStart;

    // Merge sub arrays in bottom up
    // manner. First merge sub arrays
    // of size 1 to create sorted
    // sub arrays of size 2, then merge
    // sub arrays of size 2 to create
    // sorted sub arrays of size 4, and
    // so on.
    for (currSize = 1;
        currSize <= numbers.length - 1;
        currSize = 2 * currSize) {
      // Pick starting point of different
      // sub arrays of current size
      for (leftStart = 0;
          leftStart < numbers.length - 1;
          leftStart += 2 * currSize) {
        // Find ending point of left
        // subarray. mid+1 is starting
        // point of right
        int mid = min(leftStart + currSize - 1, numbers.length - 1);

        int rightEnd = min(leftStart + 2 * currSize - 1, numbers.length - 1);

        // Merge Sub arrays arr[left_start...mid]
        // & arr[mid+1...right_end]
        merge(numbers, leftStart, mid, rightEnd);
      }
    }
  }

  void merge(List<SortModel> arr, int l, int m, int r) async {
    int i, j, k;
    int n1 = m - l + 1;
    int n2 = r - m;

    /* create temp arrays */
    List<SortModel> L = new List<SortModel>();
    List<SortModel> R = new List<SortModel>();

    /* Copy data to temp arrays L[]
        and R[] */
    for (i = 0; i < n1; i++) L.add(arr[l + i]);
    for (j = 0; j < n2; j++) R.add(arr[m + 1 + j]);

    /* Merge the temp arrays back into
        arr[l..r]*/
    i = 0;
    j = 0;
    k = l;


    while (i < n1 && j < n2) {
      if (L[i].value <= R[j].value) {
        arr[k] = L[i];
        i++;
      } else {
        arr[k] = R[j];
        j++;
      }



      k++;

    }

    /* Copy the remaining elements of
        L[], if there are any */
    while (i < n1) {
      arr[k] = L[i];
      i++;
      k++;
    }

    /* Copy the remaining elements of
        R[], if there are any */
    while (j < n2) {
      arr[k] = R[j];
      j++;
      k++;
    }


    render();
    await pause();

  }

  void printNums(List<SortModel> numbers) {
    for (int i = 0; i < numbers.length; i++) {
      print(numbers[i].value);
    }
    print("\n\n\n\n\n");
  }
}
