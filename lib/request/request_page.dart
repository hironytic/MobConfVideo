//
// request_page.dart
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
import 'package:mob_conf_video/request/request_bloc.dart';

class RequestPage extends StatelessWidget {
  RequestPage({Key key, this.bottomNavigationBar}) : super(key: key);

  final Widget bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    final RequestBloc requestBloc = BlocProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: PopupMenuButton(
          itemBuilder: _buildPopupMenuItems,
          onSelected: (value) => requestBloc.targetSelection.add(value),
          child: StreamBuilder<RequestTarget>(
            stream: requestBloc.currentTarget,
            builder: (context, snapshot) =>
                Text((snapshot.data?.name ?? "") + " \u25be"),
          ),
        ),
      ),
      body: _buildBody(context),
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  List<PopupMenuEntry<String>> _buildPopupMenuItems(BuildContext context) {
    final RequestBloc requestBloc = BlocProvider.of(context);
    return requestBloc.availableTargets
        .map((target) =>
            PopupMenuItem(value: target.id, child: Text(target.name)))
        .toList();
  }

  Widget _buildBody(BuildContext context) {
    final RequestBloc requestBloc = BlocProvider.of(context);
    return StreamBuilder<List<RequestItem>>(
      stream: requestBloc.requestItems,
      builder: (buildContext, snapshot) {
        if (snapshot.data == null) {
          return Container();
        } else if (snapshot.data.isEmpty) {
          return Center(child: Text("リクエストがありません"));
        } else {
          return ListView(
            children: ListTile.divideTiles(
                context: context,
                tiles: snapshot.data.map((item) => ListTile(
                      key: ObjectKey(item.id),
                      title: Text(item.title),
                      subtitle: Text(item.conference),
                      trailing: item.isWatched ? Icon(Icons.check) : null,
                    ))).toList(),
          );
        }
      },
    );
  }
}
