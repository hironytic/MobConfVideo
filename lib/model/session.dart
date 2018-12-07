//
// session.dart
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
import 'package:mob_conf_video/model/speaker.dart';

class Session {
  Session({
    @required this.id,
    @required this.conferenceId,
    @required this.title,
    @required this.description,
    @required this.starts,
    @required this.minutes,
    @required this.slide,
    @required this.video,
    @required this.speakers,
  });

  final String id;
  final String conferenceId;
  final String title;
  final String description;
  final DateTime starts;
  final int minutes;
  final String slide;
  final String video;
  final List<Speaker> speakers;

  Session.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.documentID, snapshot.data);

  Session.fromMap(String id, Map<String, dynamic> map)
      : this(
          id: id,
          conferenceId: map["conferenceId"],
          title: map["title"],
          description: map["description"],
          starts: (map["starts"] as Timestamp).toDate(),
          minutes: map["minutes"],
          slide: map["slide"],
          video: map["video"],
          speakers: _mapSpeakers(map["speakers"]),
        );

  static List<Speaker> _mapSpeakers(List speakers) {
    return speakers
        .map((speaker) => Speaker.fromMap(speaker as Map<dynamic, dynamic>))
        .toList();
  }
}
