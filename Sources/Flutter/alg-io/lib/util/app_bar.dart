import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  final String _text;

  MyAppBar(this._text);

  @override
  Widget build(BuildContext context) {

    double topPadding = MediaQuery.of(context).padding.top;

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
            _text,
            style: Theme.of(context).textTheme.headline2,
          )
      ),
    );


  }
}
