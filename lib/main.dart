import 'package:flutter/material.dart';
import 'package:mob_conf_video/favorite/favorite_page.dart';
import 'package:mob_conf_video/request/request_page.dart';
import 'package:mob_conf_video/video/video_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MobConfVideo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPageIndex = 0;

  void _onBottomNavigationItemTapped(int pageIndex) {
    setState(() {
      _currentPageIndex = pageIndex;
    });
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text("リクエスト")),
        BottomNavigationBarItem(
            icon: Icon(Icons.video_label),
            title: Text("動画")),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text("お気に入り")),
      ],
      currentIndex: _currentPageIndex,
      onTap: _onBottomNavigationItemTapped,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentPageIndex) {
      case 0:
        return RequestPage(
          bottomNavigationBar: _buildBottomNavigationBar(),
        );

      case 1:
        return VideoPage(
          bottomNavigationBar: _buildBottomNavigationBar(),
        );

      case 2:
        return FavoritePage(
          bottomNavigationBar: _buildBottomNavigationBar(),
        );

      default:
        return null;
    }
  }
}
