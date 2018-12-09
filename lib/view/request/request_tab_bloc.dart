//
// request_tab_bloc.dart
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
import 'package:meta/meta.dart';
import 'package:mob_conf_video/RepositoryProvider.dart';
import 'package:mob_conf_video/common/subscription_holder.dart';
import 'package:mob_conf_video/model/request.dart';
import 'package:mob_conf_video/repository/request_repository.dart';
import 'package:rxdart/rxdart.dart';

abstract class RequestListState {}

class RequestListLoading implements RequestListState {}

class RequestListLoaded implements RequestListState {
  Iterable<Request> requests;
  RequestListLoaded(this.requests);
}

class RequestListError implements RequestListState {
  String message;
  RequestListError(this.message);
}

abstract class RequestTabBloc implements Bloc {
  // inputs

  // outputs
  Stream<RequestListState> get requestListState;
}

class DefaultRequestTabBloc implements RequestTabBloc {
  @override
  get requestListState => _requestListState;

  final SubscriptionHolder _subscriptions;
  final Observable<RequestListState> _requestListState;

  DefaultRequestTabBloc._(
    this._subscriptions,
    this._requestListState,
  );

  factory DefaultRequestTabBloc({
    @required RequestRepository requestRepository,
    @required String eventId,
  }) {
    final subscriptions = SubscriptionHolder();

    final requestListState =
        Observable(requestRepository.getAllRequestsStream(eventId))
            .map<RequestListState>((requests) => RequestListLoaded(requests))
            .startWith(RequestListLoading())
            .onErrorReturnWith((error) => RequestListError(error.toString()))
            .publishValue();
    subscriptions.add(requestListState.connect());

    return DefaultRequestTabBloc._(
      subscriptions,
      requestListState,
    );
  }

  @override
  void dispose() {
    _subscriptions.dispose();
  }
}

class DefaultRequestTabBlocProvider extends BlocProvider<RequestTabBloc> {
  DefaultRequestTabBlocProvider({
    @required String eventId,
    @required Widget child,
  }) : super(
    child: child,
    creator: (context) {
      final provider = RepositoryProvider.of(context);
      return DefaultRequestTabBloc(
        requestRepository: provider.requestRepository,
        eventId: eventId,
      );
    },
  );
}
