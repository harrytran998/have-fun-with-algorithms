import 'package:flutter/material.dart';

class SortModel {
  SortModel(this.value) : key = UniqueKey();

  int value;
  final UniqueKey key;
}
