import 'package:algo_io_files/sorts/base_sort.dart';
import 'package:algo_io_files/util/app_bar.dart';
import 'package:algo_io_files/util/sort_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SortAnimation<T extends BaseSort> extends StatelessWidget {
  final String title;

  SortAnimation(this.title, {Key key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(child:


    Consumer<T>(
        builder: (context, provider, child) {
      return Column(children: <Widget>[
        MyAppBar(title),
        Expanded(
          child: SingleChildScrollView(
            child: SizedBox(
              width: width,
              height: BaseSort.getNumModels() * SortWidget.getUnitHeight(),
              child: Stack(
                children: <Widget>[
                  for (int i = 0; i < provider.numbers.length; i++)
                    SortWidget(
                      key: provider.numbers[i].key,
                      number: provider.numbers[i],
                      index: i,
                      containerWidth: width,
                    )
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.play_arrow),
              color: Theme.of(context).iconTheme.color,
              iconSize: Theme.of(context).iconTheme.size,
              onPressed: () {
                Provider.of<T>(context, listen: false).sort();
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              color: Theme.of(context).iconTheme.color,
              iconSize: Theme.of(context).iconTheme.size,
              onPressed: () {
                Provider.of<T>(context, listen: false).reset();
              },
            ),
          ],
        ),
      ]);
    }));
  }
}
