import 'package:flutter/material.dart';

class VideoPage extends StatefulWidget {
  VideoPage({Key key, this.bottomNavigationBar}) : super(key: key);

  final Widget bottomNavigationBar;

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("動画"),
      ),
      body: Center(
        child: Text("どうが"),
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
