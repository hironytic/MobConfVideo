//
// main.dart
// mob_conf_video
//
// Copyright (c) 2018 Hironori Ichimiya <hiron@hironytic.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import 'package:flutter/material.dart';
import 'package:mob_conf_video/BlocProvider.dart';
import 'package:mob_conf_video/favorite/favorite_page.dart';
import 'package:mob_conf_video/request/request_bloc.dart';
import 'package:mob_conf_video/request/request_page.dart';
import 'package:mob_conf_video/video/video_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RequestBloc>(
      createBloc: () => DefaultRequestBloc(),
      child: MaterialApp(
        title: 'MobConfVideo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
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
        BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("リクエスト")),
        BottomNavigationBarItem(
            icon: Icon(Icons.video_label), title: Text("動画")),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite), title: Text("お気に入り")),
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
