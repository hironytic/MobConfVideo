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

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:mob_conf_video/common/dropdown_state.dart';
import 'package:mob_conf_video/model/session.dart';
import 'package:mob_conf_video/view/video/video_page_bloc.dart';

class VideoPage extends StatelessWidget {
  VideoPage({Key key, this.bottomNavigationBar}) : super(key: key);

  final Widget bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("動画を見つける"),
      ),
      body: _buildBody(context),
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  Widget _buildBody(BuildContext context) {
    final VideoPageBloc videoBloc = BlocProvider.of(context);

    return StreamBuilder(
      stream: videoBloc.sessions,
      builder: (context, snapshot) {
        Iterable<SessionItem> sessions = snapshot.data;
        return ListView.builder(
          itemCount: (sessions?.length ?? 0) + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildFilterPanel(context);
            } else {
              return _buildSession(
                  context, sessions.elementAt(index - 1), index - 1);
            }
          },
        );
      },
    );
  }

  Widget _buildSession(BuildContext context, SessionItem item, int index) {
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
              Text(item.session.title, style: textTheme.headline),
              DefaultTextStyle(
                style: textTheme.body1.copyWith(color: Colors.black87),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                child: new Padding(
                  child: new Text(item.session.description),
                  padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: new Column(
                  children: _buildSpeakers(context, item.session),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  item.conferenceName,
                  style: textTheme.body1.copyWith(color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSpeakers(BuildContext context, Session session) {
    return session.speakers.map((speaker) {
      return Container(
        padding: const EdgeInsets.only(top: 4.0),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 40.0,
              height: 40.0,
              child: (speaker.icon != null)
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(speaker.icon),
                    )
                  : Container(),
            ),
            Container(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(speaker.name),
            )
          ],
        ),
      );
    }).toList();
  }

  Widget _buildFilterPanel(BuildContext context) {
    final VideoPageBloc videoBloc = BlocProvider.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder(
        stream: videoBloc.isFilterPanelExpanded,
        builder: (context, snapshot) {
          return ExpansionPanelList(
            expansionCallback: (index, isExpanded) {
              if (index == 0) {
                videoBloc.expandFilterPanel.add(!isExpanded);
              }
            },
            children: <ExpansionPanel>[
              ExpansionPanel(
                isExpanded: snapshot.data ?? false,
                headerBuilder: (context, isExpanded) {
                  return Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 24.0),
                          child: Text(
                            "フィルタ",
                            style: Theme.of(context).textTheme.body2,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                body: _buildFilterBody(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
          child: _buildFilterContent(context),
        ),
        const Divider(height: 1.0),
        _buildFilterButtonArea(context),
      ],
    );
  }

  Widget _buildFilterContent(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final textTheme = themeData.textTheme;
    final VideoPageBloc videoBloc = BlocProvider.of(context);

    return Row(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text("カンファレンス", style: textTheme.caption),
            ),
            buildStatefulDropdownButton(
              state: videoBloc.filterConference,
              onChanged: videoBloc.filterConferenceChanged,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text("セッション時間", style: textTheme.caption),
            ),
            buildStatefulDropdownButton(
              state: videoBloc.filterSessionTime,
              onChanged: videoBloc.filterSessionTimeChanged,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterButtonArea(BuildContext context) {
    final VideoPageBloc videoBloc = BlocProvider.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: FlatButton(
              onPressed: () => videoBloc.executeFilter.add(null),
              textTheme: ButtonTextTheme.accent,
              child: const Text('実行'),
            ),
          ),
        ],
      ),
    );
  }

  void _onTapSession(int index) {}
}
