import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({Key key, this.bottomNavigationBar}) : super(key: key);

  final Widget bottomNavigationBar;

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("お気に入り"),
      ),
      body: Center(
        child: Text("はーと"),
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
