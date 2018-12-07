//
// video_page_bloc.dart
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
import 'package:flutter/widgets.dart';
import 'package:tuple/tuple.dart';
import 'package:mob_conf_video/common/dropdown_state.dart';
import 'package:mob_conf_video/common/subscription_holder.dart';
import 'package:mob_conf_video/model/conference.dart';
import 'package:mob_conf_video/model/session.dart';
import 'package:mob_conf_video/repository/conference_repository.dart';
import 'package:mob_conf_video/repository/session_repository.dart';
import 'package:rxdart/rxdart.dart';

enum SessionTime {
  notSpecified,
  within15Minutes,
  within30Minutes,
  within60Minutes,
}

class SessionItem {
  final Session session;
  final String conferenceName;

  SessionItem({
    @required this.session,
    @required this.conferenceName,
  });
}

abstract class VideoPageBloc implements Bloc {
  // inputs
  Sink<bool> get expandFilterPanel;
  Sink<String> get filterConferenceChanged;
  Sink<SessionTime> get filterSessionTimeChanged;
  Sink<void> get executeFilter;

  // outputs
  Stream<bool> get isFilterPanelExpanded;
  Stream<DropdownState<String>> get filterConference;
  Stream<DropdownState<SessionTime>> get filterSessionTime;
  Stream<Iterable<SessionItem>> get sessions;
}

class DefaultVideoPageBloc implements VideoPageBloc {
  // inputs
  get expandFilterPanel => _expandFilterPanel;
  get filterConferenceChanged => _filterConferenceChanged;
  get filterSessionTimeChanged => _filterSessionTimeChanged;
  get executeFilter => _executeFilter;

  // outputs
  get isFilterPanelExpanded => _isFilterPanelExpanded;
  get filterConference => _filterConference;
  get filterSessionTime => _filterSessionTime;
  get sessions => _sessions;

  final SubscriptionHolder _subscriptions;
  final PublishSubject<bool> _expandFilterPanel;
  final PublishSubject<String> _filterConferenceChanged;
  final PublishSubject<SessionTime> _filterSessionTimeChanged;
  final PublishSubject<void> _executeFilter;
  final Observable<bool> _isFilterPanelExpanded;
  final Observable<DropdownState<String>> _filterConference;
  final Observable<DropdownState<SessionTime>> _filterSessionTime;
  final Observable<Iterable<SessionItem>> _sessions;

  DefaultVideoPageBloc._(
    this._subscriptions,
    this._expandFilterPanel,
    this._filterConferenceChanged,
    this._filterSessionTimeChanged,
    this._executeFilter,
    this._isFilterPanelExpanded,
    this._filterConference,
    this._filterSessionTime,
    this._sessions,
  );

  factory DefaultVideoPageBloc({
    @required ConferenceRepository conferenceRepository,
    @required SessionRepository sessionRepository,
  }) {
    final subscriptions = SubscriptionHolder();

    // ignore: close_sinks
    final expandFilterPanel = PublishSubject<bool>();
    // ignore: close_sinks
    final filterConferenceChanged = PublishSubject<String>();
    // ignore: close_sinks
    final filterSessionTimeChanged = PublishSubject<SessionTime>();
    // ignore: close_sinks
    final executeFilter = PublishSubject<void>();

    final isFilterPanelExpanded = Observable.merge([
      expandFilterPanel,
      executeFilter.map((_) => false), // also closes on executing the filter
    ]).startWith(true).publishValue();
    subscriptions.add(isFilterPanelExpanded.connect());

    final conferences =
        Observable(conferenceRepository.getAllConferencesStream())
            .map((conferences) => conferences.toList())
            .share();

    final currentConferenceFilter = Observable.concat([
      conferences
          .take(1)
          .map((conferences) => (conferences.length > 0) ? conferences[0].id : null),
      filterConferenceChanged,
    ]).distinct().share();

    final filterConference = Observable.combineLatest2(
      currentConferenceFilter,
      conferences,
      (v1, v2) => Tuple2<String, List<Conference>>(v1, v2),
    )
        .map((value) {
          return DropdownState<String>(
            value: value.item1,
            items: value.item2.map(
              (conf) => DropdownStateItem<String>(
                    value: conf.id,
                    title: conf.name,
                  ),
            ),
          );
        })
        .onErrorReturn(
          DropdownState<String>(
            value: "",
            items: [DropdownStateItem<String>(value: "", title: "<<エラー>>")],
          ),
        )
        .publishValue();
    subscriptions.add(filterConference.connect());

    final sessionTimeItems = [
      DropdownStateItem(value: SessionTime.notSpecified, title: "指定なし"),
      DropdownStateItem(value: SessionTime.within15Minutes, title: "15分以内"),
      DropdownStateItem(value: SessionTime.within30Minutes, title: "30分以内"),
      DropdownStateItem(value: SessionTime.within60Minutes, title: "60分以内"),
    ];

    final currentSessionTimeFilter = filterSessionTimeChanged
        .startWith(SessionTime.notSpecified)
        .distinct()
        .share();

    final filterSessionTime = currentSessionTimeFilter
        .map((value) => DropdownState<SessionTime>(
              value: value,
              items: sessionTimeItems,
            ))
        .onErrorReturn(
          DropdownState<SessionTime>(
            value: SessionTime.notSpecified,
            items: [
              DropdownStateItem<SessionTime>(
                  value: SessionTime.notSpecified, title: "<<エラー>>")
            ],
          ),
        )
        .publishValue();
    subscriptions.add(filterSessionTime.connect());

    final currentFilters = Observable.combineLatest2(
      currentConferenceFilter,
      currentSessionTimeFilter,
      (v1, v2) {
        return Tuple2<String, SessionTime>(v1, v2);
      },
    );

    final sessionFilter = executeFilter
        .withLatestFrom<Tuple2<String, SessionTime>,
                Tuple2<String, SessionTime>>(
            currentFilters, (void e, Tuple2<String, SessionTime> v) => v)
        .map((v) {
      return SessionFilter(
          conferenceId: v.item1,
          withinMinutes: _withinMinutesFromSessionTime(v.item2));
    });

    final sessions = sessionFilter
        .switchMap(
            (filter) => Observable(sessionRepository.getSessionsStream(filter)))
        .map((sessions) => sessions.map(
            (session) => SessionItem(session: session, conferenceName: "")))
        .startWith([])
        .publishValue();
    subscriptions.add(sessions.connect());

    return DefaultVideoPageBloc._(
      subscriptions,
      expandFilterPanel,
      filterConferenceChanged,
      filterSessionTimeChanged,
      executeFilter,
      isFilterPanelExpanded,
      filterConference,
      filterSessionTime,
      sessions,
    );
  }

  static int _withinMinutesFromSessionTime(SessionTime sessionTime) {
    int withinMinutes;
    switch (sessionTime) {
      case SessionTime.notSpecified:
        withinMinutes = null;
        break;
      case SessionTime.within15Minutes:
        withinMinutes = 15;
        break;
      case SessionTime.within30Minutes:
        withinMinutes = 30;
        break;
      case SessionTime.within60Minutes:
        withinMinutes = 60;
        break;
    }
    return withinMinutes;
  }

  void dispose() {
    _subscriptions.dispose();
    _expandFilterPanel.close();
    _filterConferenceChanged.close();
    _filterSessionTimeChanged.close();
    _executeFilter.close();
  }
}
