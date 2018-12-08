//
// RepositoryProvider.dart
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

import 'package:flutter/widgets.dart';
import 'package:mob_conf_video/repository/conference_repository.dart';
import 'package:mob_conf_video/repository/event_repository.dart';
import 'package:mob_conf_video/repository/request_repository.dart';
import 'package:mob_conf_video/repository/session_repository.dart';

class RepositoryProvider extends InheritedWidget {
  final EventRepository eventRepository;
  final RequestRepository requestRepository;
  final ConferenceRepository conferenceRepository;
  final SessionRepository sessionRepository;

  RepositoryProvider({
    Key key,
    Widget child,
    @required this.eventRepository,
    @required this.requestRepository,
    @required this.conferenceRepository,
    @required this.sessionRepository,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static RepositoryProvider of(BuildContext context) {
    return context
        .ancestorInheritedElementForWidgetOfExactType(RepositoryProvider)
        .widget as RepositoryProvider;
  }
}
