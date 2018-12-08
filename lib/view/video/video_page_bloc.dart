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
  fiveMinutes,
  fifteenMinutes,
  thirtyMinutes,
  fiftyMinutes,
}

class SessionItem {
  final Session session;
  final String conferenceName;

  SessionItem({
    @required this.session,
    @required this.conferenceName,
  });
}

abstract class SessionListState {}

class SessionListInitial implements SessionListState {}

class SessionListLoading implements SessionListState {}

class SessionListLoaded implements SessionListState {
  Iterable<SessionItem> sessions;
  SessionListLoaded(this.sessions);
}

class SessionListError implements SessionListState {
  String message;
  SessionListError(this.message);
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
  Stream<SessionListState> get sessionListState;
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
  get sessionListState => _sessionListState;

  final SubscriptionHolder _subscriptions;
  final PublishSubject<bool> _expandFilterPanel;
  final PublishSubject<String> _filterConferenceChanged;
  final PublishSubject<SessionTime> _filterSessionTimeChanged;
  final PublishSubject<void> _executeFilter;
  final Observable<bool> _isFilterPanelExpanded;
  final Observable<DropdownState<String>> _filterConference;
  final Observable<DropdownState<SessionTime>> _filterSessionTime;
  final Observable<SessionListState> _sessionListState;

  DefaultVideoPageBloc._(
    this._subscriptions,
    this._expandFilterPanel,
    this._filterConferenceChanged,
    this._filterSessionTimeChanged,
    this._executeFilter,
    this._isFilterPanelExpanded,
    this._filterConference,
    this._filterSessionTime,
    this._sessionListState,
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
            .shareValue();

    final currentConferenceFilter =
        filterConferenceChanged.startWith("").distinct().shareValue();

    final filterConference = Observable.combineLatest2(
      currentConferenceFilter,
      conferences,
      (v1, v2) => Tuple2<String, List<Conference>>(v1, v2),
    )
        .map((value) {
          return DropdownState<String>(
            value: value.item1,
            items: _appendNotSpecified(
              value.item2.map(
                (conf) => DropdownStateItem<String>(
                      value: conf.id,
                      title: conf.name,
                    ),
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
      DropdownStateItem(value: SessionTime.fiveMinutes, title: "5分"),
      DropdownStateItem(value: SessionTime.fifteenMinutes, title: "15分"),
      DropdownStateItem(value: SessionTime.thirtyMinutes, title: "30分"),
      DropdownStateItem(value: SessionTime.fiftyMinutes, title: "50分"),
    ];

    final currentSessionTimeFilter = filterSessionTimeChanged
        .startWith(SessionTime.notSpecified)
        .distinct()
        .shareValue();

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
        conferenceId: _getConferenceId(v.item1),
        minutes: _getMinutesFromSessionTime(v.item2),
      );
    });

    convertSession(Map<String, String> conferenceNameMap) {
      return (Session session) {
        return SessionItem(
          session: session,
          conferenceName: conferenceNameMap[session.conferenceId],
        );
      };
    }

    Map<String, String> makeConferenceNameMap(List<Conference> conferences) {
      return conferences.fold(
        Map<String, String>(),
        (map, conference) {
          map[conference.id] = conference.name;
          return map;
        },
      );
    }

    Observable<SessionListState> loadSessions(SessionFilter filter) {
      return Observable.combineLatest2(
        Observable(sessionRepository.getSessionsStream(filter)),
        conferences,
        (sessions, conferences) =>
            Tuple2<Iterable<Session>, Map<String, String>>(
                sessions, makeConferenceNameMap(conferences)),
      )
          .map<SessionListState>((tuple) =>
              SessionListLoaded(tuple.item1.map(convertSession(tuple.item2))))
          .startWith(SessionListLoading());
    }

    final sessionListState = sessionFilter
        .switchMap(loadSessions)
        .startWith(SessionListInitial())
        .onErrorReturnWith((error) => SessionListError(error.toString()))
        .publishValue();
    subscriptions.add(sessionListState.connect());

    return DefaultVideoPageBloc._(
      subscriptions,
      expandFilterPanel,
      filterConferenceChanged,
      filterSessionTimeChanged,
      executeFilter,
      isFilterPanelExpanded,
      filterConference,
      filterSessionTime,
      sessionListState,
    );
  }

  static int _getMinutesFromSessionTime(SessionTime sessionTime) {
    int withinMinutes;
    switch (sessionTime) {
      case SessionTime.notSpecified:
        withinMinutes = null;
        break;
      case SessionTime.fiveMinutes:
        withinMinutes = 5;
        break;
      case SessionTime.fifteenMinutes:
        withinMinutes = 15;
        break;
      case SessionTime.thirtyMinutes:
        withinMinutes = 30;
        break;
      case SessionTime.fiftyMinutes:
        withinMinutes = 50;
        break;
    }
    return withinMinutes;
  }

  static String _getConferenceId(String conferenceId) {
    if (conferenceId == null || conferenceId.isEmpty) {
      return null;
    } else {
      return conferenceId;
    }
  }

  static Iterable<DropdownStateItem<String>> _appendNotSpecified(
      Iterable<DropdownStateItem<String>> iterable) {
    return [
      [DropdownStateItem<String>(value: "", title: "指定なし")],
      iterable,
    ].expand((x) => x);
  }

  void dispose() {
    _subscriptions.dispose();
    _expandFilterPanel.close();
    _filterConferenceChanged.close();
    _filterSessionTimeChanged.close();
    _executeFilter.close();
  }
}
