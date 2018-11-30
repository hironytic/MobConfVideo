//
// request_repository.dart
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

import 'package:mob_conf_video/model/request.dart';

abstract class RequestRepository {
  Stream<List<Request>> getAllRequestsStream(String eventId);
}

class DefaultRequestRepository implements RequestRepository {
  Stream<List<Request>> getAllRequestsStream(String eventId) {
    switch (eventId) {
      case "id0":
        return Stream.fromIterable([
          <Request>[
            Request(
              id: "aaa",
              title: "スマホアプリエンジニアだから知ってほしいブロックチェーンと分散型アプリケーション",
              conference: "iOSDC Japan 2018",
              isWatched: true,
              videoUrl: null,
              slideUrl: null,
              sessionId: null,
              memo: null,
            ),
            Request(
              id: "bbb",
              title: "DDD(ドメイン駆動設計)を知っていますか？？",
              conference: "iOSDC 2018 Reject Conference",
              isWatched: true,
              videoUrl: null,
              slideUrl: null,
              sessionId: null,
              memo: null,
            ),
            Request(
              id: "ccc",
              title: "再利用可能なUI Componentsを利用したアプリ開発",
              conference: "iOSDC Japan 2018",
              isWatched: false,
              videoUrl: null,
              slideUrl: null,
              sessionId: null,
              memo: null,
            ),
          ]
        ]);

      case "id1":
        return Stream.fromIterable([
          <Request>[
            Request(
              id: "aaa",
              title: "50 分でわかるテスト駆動開発",
              conference: "de:code 2017",
              isWatched: true,
              videoUrl: null,
              slideUrl: null,
              sessionId: null,
              memo: null,
            ),
            Request(
              id: "bbb",
              title: "テストライブコーディング",
              conference: "iOSDC 2018 Reject Conference",
              isWatched: true,
              videoUrl: null,
              slideUrl: null,
              sessionId: null,
              memo: null,
            ),
            Request(
              id: "ccc",
              title: "テストライブコーディング",
              conference: "iOSDC 2018 Reject Conference",
              isWatched: true,
              videoUrl: null,
              slideUrl: null,
              sessionId: null,
              memo: null,
            ),
            Request(
              id: "ccc",
              title: "Kotlin コルーチンを理解しよう",
              conference: "Kotlin Fest 2018",
              isWatched: true,
              videoUrl: null,
              slideUrl: null,
              sessionId: null,
              memo: null,
            ),
            Request(
              id: "ccc",
              title: "Kioskアプリと端末の作り方",
              conference: "DroidKaigi 2018",
              isWatched: true,
              videoUrl: null,
              slideUrl: null,
              sessionId: null,
              memo: null,
            ),
            Request(
              id: "ccc",
              title: "アプリをエミュレートするアプリの登場とその危険性",
              conference: "DroidKaigi 2018",
              isWatched: true,
              videoUrl: null,
              slideUrl: null,
              sessionId: null,
              memo: null,
            ),
          ]
        ]);

      default:
        return Stream.fromIterable([<Request>[]]);
    }
  }
}
