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
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final RequestBloc requestBloc = BlocProvider.of(context);
    Color downArrowColor;
    if (Theme.of(context).primaryColorBrightness == Brightness.light) {
      downArrowColor = Colors.grey.shade700;
    } else {
      downArrowColor = Colors.white70;
    }

    return AppBar(
      title: PopupMenuButton(
        itemBuilder: (context) {
          return requestBloc.availableTargets
              .map((target) =>
              PopupMenuItem(value: target.id, child: Text(target.name)))
              .toList();
        },
        onSelected: (value) => requestBloc.targetSelection.add(value),
        child: StreamBuilder<RequestTarget>(
            stream: requestBloc.currentTarget,
            builder: (context, snapshot) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text((snapshot.data?.name ?? "")),
                  Icon(Icons.arrow_drop_down,
                    size: 24.0,
                    color: downArrowColor,
                  ),

                ],
              );
            }
        ),
      ),
    );
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
          final items = snapshot.data;
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                key: ObjectKey(item.id),
                title: Text(item.title),
                subtitle: Text(item.conference),
                trailing: item.isWatched ? Icon(Icons.check) : null,
              );
            },
          );
        }
      },
    );
  }
}
