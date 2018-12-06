//
// request.dart
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Request {
  final String id;
  final String sessionId;
  final String title;
  final String conference;
  final String videoUrl;
  final String slideUrl;
  final String memo;
  final bool isWatched;

  Request({
    @required this.id,
    @required this.sessionId,
    @required this.title,
    @required this.conference,
    @required this.videoUrl,
    @required this.slideUrl,
    @required this.memo,
    @required this.isWatched,
  });

  Request.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.documentID, snapshot.data);

  Request.fromMap(String id, Map<String, dynamic> map)
      : this(
          id: id,
          sessionId: map["sessionId"],
          title: map["title"],
          conference: map["conference"],
          videoUrl: map["video"],
          slideUrl: map["slide"],
          memo: map["memo"],
          isWatched: map["watched"],
        );
}
