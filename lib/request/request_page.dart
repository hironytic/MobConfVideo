import 'package:flutter/material.dart';

class RequestPage extends StatefulWidget {
  RequestPage({Key key, this.bottomNavigationBar}) : super(key: key);

  final Widget bottomNavigationBar;

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("リクエスト"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("hogehoge"),
          ),
          Divider(),
          ListTile(
            title: Text("foo bar"),
          ),
          Divider(),
        ],
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
