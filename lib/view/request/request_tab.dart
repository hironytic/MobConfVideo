//
// request_tab.dart
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
import 'package:mob_conf_video/model/request.dart';
import 'package:mob_conf_video/view/request/request_tab_bloc.dart';

class RequestTab extends StatelessWidget {
  RequestTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RequestTabBloc requestBloc = BlocProvider.of(context);
    return StreamBuilder<RequestListState>(
      stream: requestBloc.requestListState,
      builder: (buildContext, snapshot) {
        final requestListState = snapshot.data;
        if (requestListState is RequestListLoaded) {
          return _buildLoadedBody(context, requestListState);
        } else if (requestListState is RequestListError) {
          return _buildErrorBody(context, requestListState);
        } else {
          return _buildLoadingBody(context);
        }
      },
    );
  }

  Widget _buildErrorBody(BuildContext context, RequestListError state) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return Center(
      child: Column(
        children: <Widget>[
          Text(
            "エラーが発生しました",
            style: textTheme.body1.copyWith(color: Colors.black54),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              state.message,
              style: textTheme.body1.copyWith(color: Colors.black26),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingBody(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildLoadedBody(BuildContext context, RequestListLoaded state) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    if (state.requests.isEmpty) {
      return Center(
          child: Text(
        "リクエストがありません",
        style: textTheme.body1.copyWith(color: Colors.black54),
      ));
    } else {
      final requests = state.requests;
      return ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          return _buildRequestItem(
            context,
            requests.elementAt(index),
            index,
          );
        },
      );
    }
  }

  Widget _buildRequestItem(BuildContext context, Request request, int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final IconThemeData iconThemeData = themeData.iconTheme;
    final iconSize = iconThemeData.size ?? 24.0;

    return Card(
      key: ObjectKey(request.id),
      child: InkWell(
        onTap: () => _onTapRequest(index),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    request.conference,
                    style: textTheme.body1.copyWith(color: Colors.black54),
                  ),
                  request.isWatched
                      ? Icon(
                          Icons.check,
                          color: Colors.green,
                          size: iconSize,
                        )
                      : Container(
                          width: iconSize,
                          height: iconSize,
                        ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(request.title, style: textTheme.subhead),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTapRequest(int index) {}
}
