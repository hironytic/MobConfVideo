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

import 'dart:async';
import 'dart:math';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:mob_conf_video/model/event.dart';
import 'package:mob_conf_video/view/request/request_page_bloc.dart';
import 'package:mob_conf_video/view/request/request_tab.dart';
import 'package:mob_conf_video/view/request/request_tab_bloc.dart';

class RequestPage extends StatefulWidget {
  RequestPage({Key key, this.bottomNavigationBar}) : super(key: key);

  final Widget bottomNavigationBar;

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage>
    with TickerProviderStateMixin {
  List<Event> _allEvents;
  TabController _tabController;
  List<TabController> _oldTabControllers = [];
  StreamSubscription<Iterable<Event>> _allEventsSubscription;

  @override
  void initState() {
    super.initState();

    final RequestPageBloc requestBloc = BlocProvider.of(context);
    _allEventsSubscription = requestBloc.allEvents.listen(onAllEventsChanged);
  }

  @override
  void dispose() {
    _allEventsSubscription?.cancel();
    _allEventsSubscription = null;

    super.dispose();
  }

  void onAllEventsChanged(Iterable<Event> allEvents) {
    setState(() {
      _allEvents = allEvents.toList();
      int initialIndex = min(
        _tabController?.index ?? _allEvents.length - 1,
        _allEvents.length - 1,
      );
      if (_tabController != null) {
        _oldTabControllers.add(_tabController);
      }
      _tabController = TabController(
        initialIndex: initialIndex,
        length: _allEvents.length,
        vsync: this,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bottom;
    Widget body;
    if (_tabController != null) {
      bottom = TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: _allEvents.map((event) => Tab(text: event.name)).toList(),
      );
      body = TabBarView(
        controller: _tabController,
        children: _allEvents.map((event) => _buildTab(event.id)).toList(),
      );
    } else {
      bottom = null;
      body = Container();
    }

    final built = Scaffold(
      appBar: AppBar(
        title: Text("リクエスト"),
        bottom: bottom,
      ),
      body: body,
      bottomNavigationBar: widget.bottomNavigationBar,
    );

    // FIXME: dispose old controllers later...
    scheduleMicrotask(() {
      _oldTabControllers.forEach((controller) => controller.dispose());
      _oldTabControllers.clear();
    });

    return built;
  }

  Widget _buildTab(String eventId) {
    return DefaultRequestTabBlocProvider(
      eventId: eventId,
      child: RequestTab(),
    );
  }
}
