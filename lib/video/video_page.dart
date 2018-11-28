//
// video_page.dart
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

class VideoPage extends StatefulWidget {
  VideoPage({Key key, this.bottomNavigationBar}) : super(key: key);

  final Widget bottomNavigationBar;

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  bool _isFilterExpanded = false;

  _setFilterExpanded(value) {
    setState(() {
      _isFilterExpanded = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("動画"),
      ),
      body: _buildBody(context),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView.builder(
      itemCount: 10 + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildFilterPanel(context);
        } else {
          return _buildSession(context, index - 1);
        }
      },
    );
  }

  Widget _buildSession(BuildContext context, int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return Card(
      child: InkWell(
          onTap: () => _onTapSession(index),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("タイトルがどうこうしてもそうするとは言えないはなし", style: textTheme.headline),
                  DefaultTextStyle(
                    style: textTheme.body1.copyWith(color: Colors.black54),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    child: new Padding(
                      child: new Text(
                          "いっけなーい💦トークトーク🗣私、ひろん。今年もiOSDCのLTに応募したの✨でもiOSDCは競技LT🏅オーディエンスもいっぱいいるから緊張してしゃべれないよー🙀あ、そうだ💡AVSpeechSynthesizerちゃんとPDF Kitくんに頼めば、代わりに発表してくれるんじゃない？💕私あったまいいー…って本当に採択されたらどうしよう🆘次回「全部iOSにしゃべらせちゃえ！」お楽しみに"),
                      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: new Column(
                      children: _buildSpeakers(context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text("hoge $index",
                        style: textTheme.body1.copyWith(color: Colors.black54)),
                  ),
                ],
              ))),
    );
  }

  List<Widget> _buildSpeakers(BuildContext context) {
    return <Widget>[
      Container(
        padding: const EdgeInsets.only(top: 4.0),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 32.0,
              height: 32.0,
//              child: Image(image:),
            ),
            Container(
              child: Text("ひろん"),
            )
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.only(top: 4.0),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 32.0,
              height: 32.0,
//              child: Image(image:),
            ),
            Container(
              child: Text("Hogeta Fugao"),
            )
          ],
        ),
      ),
    ];
  }

  Widget _buildFilterPanel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ExpansionPanelList(
        expansionCallback: (index, isExpanded) {
          if (index == 0) {
            _setFilterExpanded(!isExpanded);
          }
        },
        children: <ExpansionPanel>[
          ExpansionPanel(
            isExpanded: _isFilterExpanded,
            headerBuilder: (context, isExpanded) {
              return Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.only(left: 24.0),
                    child:
                        Text("フィルタ", style: Theme.of(context).textTheme.body2),
                  )),
                ],
              );
            },
            body: _buildFilterBody(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBody(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final textTheme = themeData.textTheme;

    return Column(
      children: <Widget>[
        Container(
            margin:
                const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
            child: Center(
                child: DefaultTextStyle(
              style: textTheme.caption.copyWith(fontSize: 15.0),
              child: Container(
                width: 100,
                height: 100,
              ),
            ))),
        const Divider(height: 1.0),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      child: FlatButton(
                          onPressed: _onFilterDone,
                          textTheme: ButtonTextTheme.accent,
                          child: const Text('実行')))
                ]))
      ],
    );
  }

  _onFilterDone() {
    _setFilterExpanded(false);
  }

  _onTapSession(int index) {}
}
