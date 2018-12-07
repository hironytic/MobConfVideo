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
import 'package:mob_conf_video/common/subscription_holder.dart';
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
  // inputs
  Sink<String> get targetSelection => _targetSelection;

  // outputs
  Stream<Event> get currentTarget => _currentTarget;
  List<Event> get availableTargets => _allEvents.value;
  Stream<Iterable<Request>> get requests => _requests;

  final SubscriptionHolder _subscriptions;
  final PublishSubject<String> _targetSelection;
  final Observable<Event> _currentTarget;
  final ValueObservable<List<Event>> _allEvents;
  final Observable<Iterable<Request>> _requests;

  DefaultRequestPageBloc._(
    this._subscriptions,
    this._targetSelection,
    this._currentTarget,
    this._allEvents,
    this._requests,
  );

  factory DefaultRequestPageBloc({
    @required EventRepository eventRepository,
    @required RequestRepository requestRepository,
  }) {
    final subscriptions = SubscriptionHolder();

    // ignore: close_sinks
    final targetSelection = PublishSubject<String>();

    final allEvents = Observable(eventRepository.getAllEventsStream())
        .map((iterable) => iterable.toList())
        .publishValue();
    subscriptions.add(allEvents.connect());

    // The default selection is the request which is the first one
    // in the first all-events-list
    final targetSelectionWithDefault = Observable.concat([
      allEvents
          .take(1)
          .map((events) => (events.length > 0) ? events[0].id : null),
      targetSelection,
    ]).distinct().shareValue();

    final currentTarget = targetSelectionWithDefault.withLatestFrom(
      allEvents,
      (eventId, List<Event> events) {
        if (eventId == null) {
          return null;
        }
        return events.firstWhere(
          (event) => event.id == eventId,
          orElse: () => null,
        );
      },
    ).publishValue();
    subscriptions.add(currentTarget.connect());

    final requests = targetSelectionWithDefault.switchMap(
      (eventId) {
        if (eventId == null) {
          return Observable<Iterable<Request>>.empty();
        } else {
          return Observable(requestRepository.getAllRequestsStream(eventId));
        }
      },
    ).publishValue();
    subscriptions.add(requests.connect());

    return DefaultRequestPageBloc._(
      subscriptions,
      targetSelection,
      currentTarget,
      allEvents,
      requests,
    );
  }

  void dispose() {
    _subscriptions.dispose();
    _targetSelection.close();
  }
}
