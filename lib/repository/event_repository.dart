//
// event_repository.dart
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

import 'package:mob_conf_video/model/event.dart';

abstract class EventRepository {
  Stream<List<Event>> getAllEventsStream();
}

class DefaultEventRepository implements EventRepository {
  Stream<List<Event>> getAllEventsStream() {
    return Stream.fromIterable([
      [
        Event(
          id: "id3",
          name: "第3回 カンファレンス動画鑑賞会",
          isAccepting: true,
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
      ]
    ]);
  }
}
