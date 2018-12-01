//
// request_page_bloc.dart
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

import 'package:bloc_provider/bloc_provider.dart';
import 'package:meta/meta.dart';
import 'package:mob_conf_video/common/hot_observables_holder.dart';
import 'package:mob_conf_video/model/request.dart';
import 'package:mob_conf_video/model/event.dart';
import 'package:mob_conf_video/repository/event_repository.dart';
import 'package:mob_conf_video/repository/request_repository.dart';
import 'package:rxdart/rxdart.dart';

abstract class RequestPageBloc implements Bloc {
  // inputs
  Sink<String> get targetSelection;

  // outputs
  Stream<Event> get currentTarget;
  List<Event> get availableTargets;
  Stream<Iterable<Request>> get requests;
}

class DefaultRequestPageBloc implements RequestPageBloc {
  Sink<String> get targetSelection => _targetSelection.sink;

  Stream<Event> get currentTarget => _currentTarget;
  List<Event> get availableTargets => _availableTargets;
  Stream<Iterable<Request>> get requests => _requests;

  final EventRepository eventRepository;
  final RequestRepository requestRepository;

  final _hotObservablesHolder = HotObservablesHolder();
  final _targetSelection = PublishSubject<String>();
  Observable<Event> _currentTarget;
  List<Event> _availableTargets = [];
  StreamSubscription<List<Event>> _allEventsSubscription;
  Observable<Iterable<Request>> _requests;

  DefaultRequestPageBloc({
    @required this.eventRepository,
    @required this.requestRepository,
  }) {
    final allEvents = Observable(eventRepository.getAllEventsStream())
        .map ((iterable) => iterable.toList())
        .shareReplay(maxSize: 1);

    _allEventsSubscription = allEvents.listen((events) {
      _availableTargets = events;
    });

    // The default selection is the request which is the first one
    // in the first all-events-list
    final targetSelectionWithDefault = Observable.concat([
      allEvents.take(1).map((events) => (events.length > 0) ? events[0].id : null),
      _targetSelection,
    ]).distinct().shareReplay(maxSize: 1);

    final currentTarget = targetSelectionWithDefault.withLatestFrom(allEvents,
        (eventId, List<Event> events) {
      if (eventId == null) {
        return null;
      }
      return events.firstWhere((event) => event.id == eventId, orElse: () => null);
    });
    _currentTarget = _hotObservablesHolder.replayConnect(currentTarget);

    final requests = targetSelectionWithDefault.switchMap((eventId) {
      if (eventId == null) {
        return Observable<Iterable<Request>>.empty();
      } else {
        return Observable(requestRepository.getAllRequestsStream(eventId));
      }
    });
    _requests = _hotObservablesHolder.replayConnect(requests);
  }

  void dispose() {
    _hotObservablesHolder.dispose();
    _targetSelection.close();
    _allEventsSubscription.cancel();
  }
}
