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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mob_conf_video/model/request.dart';

abstract class RequestRepository {
  Stream<Iterable<Request>> getAllRequestsStream(String eventId);
}

class DefaultRequestRepository implements RequestRepository {
  @override
  Stream<Iterable<Request>> getAllRequestsStream(String eventId) {
    var snapshots = Firestore.instance
        .collection("events")
        .document(eventId)
        .collection("requests")
        .orderBy("requestedAt", descending: false)
        .snapshots();
    return snapshots.map((snapshot) {
      return snapshot.documents.map((document) {
        return Request.fromSnapshot(document);
      });
    });
  }
}
