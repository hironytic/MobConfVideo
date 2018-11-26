//
// request_bloc.dart
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

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class RequestTarget {
  RequestTarget({this.id, this.name, this.isAccepting});

  final String id;
  final String name;
  final bool isAccepting;
}

class RequestItem {
  RequestItem(
      {this.id,
      this.sessionId,
      this.title,
      this.conference,
      this.videoUrl,
      this.slideUrl,
      this.message,
      this.isWatched});

  final String id;
  final String sessionId;
  final String title;
  final String conference;
  final String videoUrl;
  final String slideUrl;
  final String message;
  final bool isWatched;
}

abstract class RequestBloc {
  // inputs
  Sink<String> get targetSelection;

  // outputs
  Stream<RequestTarget> get currentTarget;
  List<RequestTarget> get availableTargets;
  Stream<List<RequestItem>> get requestItems;
}

class DefaultRequestBloc implements RequestBloc {
  Sink<String> get targetSelection => _targetSelection.sink;

  Stream<RequestTarget> get currentTarget => _currentTarget;
  Stream<List<RequestItem>> get requestItems => _requestItems;

  final PublishSubject<String> _targetSelection = PublishSubject();
  Observable<RequestTarget> _currentTarget;
  Observable<List<RequestItem>> _requestItems;

  List<StreamSubscription<dynamic>> _subscriptions = new List();

  List<RequestTarget> get availableTargets {
    return [
      RequestTarget(
        id: "id3",
        name: "第3回 カンファレンス動画鑑賞会",
        isAccepting: false,
      ),
      RequestTarget(
        id: "id2",
        name: "第2回 カンファレンス動画鑑賞会",
        isAccepting: false,
      ),
      RequestTarget(
        id: "id1",
        name: "第1回 カンファレンス動画鑑賞会",
        isAccepting: false,
      ),
      RequestTarget(
        id: "id0",
        name: "第0回 カンファレンス動画鑑賞会",
        isAccepting: false,
      ),
    ];
  }

  Observable<T> _replayAutoConnect<T>(Observable<T> source) {
    return source.publishReplay(maxSize: 1).autoConnect(
        connection: (subscription) => _subscriptions.add(subscription));
  }

  DefaultRequestBloc() {
    final targetSelectionWithDefault =
        _targetSelection.startWith("id3").distinct().shareReplay(maxSize: 1);

    _currentTarget = _replayAutoConnect(targetSelectionWithDefault.map((id) {
      switch (id) {
        case "id0":
          return RequestTarget(
            id: "id0",
            name: "第0回 カンファレンス動画鑑賞会",
            isAccepting: false,
          );

        case "id1":
          return RequestTarget(
            id: "id1",
            name: "第1回 カンファレンス動画鑑賞会",
            isAccepting: false,
          );

        case "id2":
          return RequestTarget(
            id: "id2",
            name: "第2回 カンファレンス動画鑑賞会",
            isAccepting: false,
          );

        case "id3":
          return RequestTarget(
            id: "id3",
            name: "第3回 カンファレンス動画鑑賞会",
            isAccepting: true,
          );

        default:
          return null;
      }
    }));

    _requestItems =
        _replayAutoConnect(targetSelectionWithDefault.switchMap((id) {
      switch (id) {
        case "id0":
          return Observable.just(<RequestItem>[
            RequestItem(
              id: "aaa",
              title: "スマホアプリエンジニアだから知ってほしいブロックチェーンと分散型アプリケーション",
              conference: "iOSDC Japan 2018",
              isWatched: true,
            ),
            RequestItem(
              id: "bbb",
              title: "DDD(ドメイン駆動設計)を知っていますか？？",
              conference: "iOSDC 2018 Reject Conference",
              isWatched: true,
            ),
            RequestItem(
              id: "ccc",
              title: "再利用可能なUI Componentsを利用したアプリ開発",
              conference: "iOSDC Japan 2018",
              isWatched: false,
            ),
          ]);

        case "id1":
          return Observable.just(<RequestItem>[
            RequestItem(
              id: "aaa",
              title: "50 分でわかるテスト駆動開発",
              conference: "de:code 2017",
              isWatched: true,
            ),
            RequestItem(
              id: "bbb",
              title: "テストライブコーディング",
              conference: "iOSDC 2018 Reject Conference",
              isWatched: true,
            ),
            RequestItem(
              id: "ccc",
              title: "テストライブコーディング",
              conference: "iOSDC 2018 Reject Conference",
              isWatched: true,
            ),
            RequestItem(
              id: "ccc",
              title: "Kotlin コルーチンを理解しよう",
              conference: "Kotlin Fest 2018",
              isWatched: true,
            ),
            RequestItem(
              id: "ccc",
              title: "Kioskアプリと端末の作り方",
              conference: "DroidKaigi 2018",
              isWatched: true,
            ),
            RequestItem(
              id: "ccc",
              title: "アプリをエミュレートするアプリの登場とその危険性",
              conference: "DroidKaigi 2018",
              isWatched: true,
            ),
          ]);

        default:
          return Observable<List<RequestItem>>.just(<RequestItem>[]);
      }
    }));
  }

  void dispose() {
    _subscriptions.forEach((subscription) => subscription.cancel());
    _subscriptions.clear();
    _targetSelection.close();
  }
}

class RequestProvider extends InheritedWidget {
  final RequestBloc requestBloc;

  RequestProvider({
    Key key,
    RequestBloc requestBloc,
    Widget child,
  })  : requestBloc = requestBloc,
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static RequestBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(RequestProvider)
            as RequestProvider)
        .requestBloc;
  }
}
