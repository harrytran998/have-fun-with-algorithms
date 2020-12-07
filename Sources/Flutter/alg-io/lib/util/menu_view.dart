import 'package:flutter/material.dart';
import 'package:algo_io_files/util/app_bar.dart';


class MenuView extends StatelessWidget {

  final String _title;
  final List<String> _topics;

  MenuView(this._title, this._topics);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: <Widget>[
          MyAppBar(_title),
          _buildTopics(context),
        ],
      ),
    );

  }

  Widget _buildTopics(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 0),
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: createTopicsList(context),
    );
  }

  List<Widget> createTopicsList(BuildContext context) {
    List<Widget> _topicsWidget = [];
    for (int i = 0; i < _topics.length; i++) {
      _topicsWidget.add(_buildRow(context, _topics[i]));
    }

    return _topicsWidget;
  }
  void visitPage(BuildContext context, String directory) {

    Navigator.pushNamed(context, ModalRoute.of(context).settings.name + directory);

  }


  Widget _buildRow(BuildContext context, String topic) {
    final bool isEmpty = topic.isEmpty;
    return ListTile(
      title: Text(
        topic,
        style: Theme
            .of(context)
            .textTheme
            .bodyText1,
      ),

      trailing: isEmpty
          ? null
          : Icon(
        Icons.arrow_forward,
        color: IconTheme.of(context).color,
        size: IconTheme.of(context).size,
      ),
      onTap: () => visitPage(context, '/' + topic),

    );
  }






}