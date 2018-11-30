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

import 'package:bloc_provider/bloc_provider.dart';
import 'package:mob_conf_video/common/hot_observables_holder.dart';
import 'package:mob_conf_video/model/request_item.dart';
import 'package:mob_conf_video/model/event.dart';
import 'package:rxdart/rxdart.dart';

abstract class RequestBloc implements Bloc {
  // inputs
  Sink<String> get targetSelection;

  // outputs
  Stream<Event> get currentTarget;
  List<Event> get availableTargets;
  Stream<List<RequestItem>> get requestItems;
}

class DefaultRequestBloc implements RequestBloc {
  Sink<String> get targetSelection => _targetSelection.sink;

  Stream<Event> get currentTarget => _currentTarget;
  Stream<List<RequestItem>> get requestItems => _requestItems;

  final _hotObservablesHolder = new HotObservablesHolder();
  final _targetSelection = PublishSubject<String>();
  Observable<Event> _currentTarget;
  Observable<List<RequestItem>> _requestItems;

  List<Event> get availableTargets {
    return [
      Event(
        id: "id3",
        name: "第3回 カンファレンス動画鑑賞会",
        isAccepting: false,
      ),
      Event(
        id: "id2",
        name: "第2回 カンファレンス動画鑑賞会",
        isAccepting: false,
      ),
      Event(
        id: "id1",
        name: "第1回 カンファレンス動画鑑賞会",
        isAccepting: false,
      ),
      Event(
        id: "id0",
        name: "第0回 カンファレンス動画鑑賞会",
        isAccepting: false,
      ),
    ];
  }

  DefaultRequestBloc() {
    final targetSelectionWithDefault =
        _targetSelection.startWith("id3").distinct().shareReplay(maxSize: 1);

    _currentTarget = _hotObservablesHolder
        .replayConnect(targetSelectionWithDefault.map((id) {
      switch (id) {
        case "id0":
          return Event(
            id: "id0",
            name: "第0回 カンファレンス動画鑑賞会",
            isAccepting: false,
          );

        case "id1":
          return Event(
            id: "id1",
            name: "第1回 カンファレンス動画鑑賞会",
            isAccepting: false,
          );

        case "id2":
          return Event(
            id: "id2",
            name: "第2回 カンファレンス動画鑑賞会",
            isAccepting: false,
          );

        case "id3":
          return Event(
            id: "id3",
            name: "第3回 カンファレンス動画鑑賞会",
            isAccepting: true,
          );

        default:
          return null;
      }
    }));

    _requestItems = _hotObservablesHolder
        .replayConnect(targetSelectionWithDefault.switchMap((id) {
      switch (id) {
        case "id0":
          return Observable.just(<RequestItem>[
            RequestItem(
              id: "aaa",
              title: "スマホアプリエンジニアだから知ってほしいブロックチェーンと分散型アプリケーション",
              conference: "iOSDC Japan 2018",
              isWatched: true,
              videoUrl: null,
              slideUrl: null,
              sessionId: null,
              memo: null,
            ),
            RequestItem(
              id: "bbb",
              title: "DDD(ドメイン駆動設計)を知っていますか？？",
              conference: "iOSDC 2018 Reject Conference",
              isWatched: true,
              videoUrl: null,
              slideUrl: null,
              sessionId: null,
              memo: null,
            ),
            RequestItem(
              id: "ccc",
              title: "再利用可能なUI Componentsを利用したアプリ開発",
              conference: "iOSDC Japan 2018",
              isWatched: false,
              videoUrl: null,
              slideUrl: null,
              sessionId: null,
              memo: null,
            ),
          ]);

        case "id1":
          return Observable.just(<RequestItem>[
            RequestItem(
              id: "aaa",
              title: "50 分でわかるテスト駆動開発",
              conference: "de:code 2017",
              isWatched: true,
              videoUrl: null,
              slideUrl: null,
              sessionId: null,
              memo: null,
            ),
            RequestItem(
              id: "bbb",
              title: "テストライブコーディング",
              conference: "iOSDC 2018 Reject Conference",
              isWatched: true,
              videoUrl: null,
              slideUrl: null,
              sessionId: null,
              memo: null,
            ),
            RequestItem(
              id: "ccc",
              title: "テストライブコーディング",
              conference: "iOSDC 2018 Reject Conference",
              isWatched: true,
              videoUrl: null,
              slideUrl: null,
              sessionId: null,
              memo: null,
            ),
            RequestItem(
              id: "ccc",
              title: "Kotlin コルーチンを理解しよう",
              conference: "Kotlin Fest 2018",
              isWatched: true,
              videoUrl: null,
              slideUrl: null,
              sessionId: null,
              memo: null,
            ),
            RequestItem(
              id: "ccc",
              title: "Kioskアプリと端末の作り方",
              conference: "DroidKaigi 2018",
              isWatched: true,
              videoUrl: null,
              slideUrl: null,
              sessionId: null,
              memo: null,
            ),
            RequestItem(
              id: "ccc",
              title: "アプリをエミュレートするアプリの登場とその危険性",
              conference: "DroidKaigi 2018",
              isWatched: true,
              videoUrl: null,
              slideUrl: null,
              sessionId: null,
              memo: null,
            ),
          ]);

        default:
          return Observable<List<RequestItem>>.just(<RequestItem>[]);
      }
    }));
  }

  void dispose() {
    _hotObservablesHolder.dispose();
    _targetSelection.close();
  }
}
