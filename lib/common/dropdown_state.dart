//
// dropdown_state.dart
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

import 'package:flutter/material.dart';

class DropdownState<T> {
  T value;
  Iterable<DropdownStateItem<T>> items;

  DropdownState({
    @required this.value,
    @required this.items,
  });
}

class DropdownStateItem<T> {
  T value;
  String title;

  DropdownStateItem({
    @required this.value,
    @required this.title,
  });
}

Widget buildStatefulDropdownButton<T>({
  @required Stream<DropdownState<T>> state,
  @required Sink<T> onChanged,
}) {
  return StreamBuilder<DropdownState<T>>(
    stream: state,
    builder: (context, snapshot) {
      if (snapshot.data == null) {
        return Container();
      }
      return DropdownButton(
        value: snapshot.data.value,
        items: snapshot.data.items.map((item) {
          return DropdownMenuItem(
            value: item.value,
            child: Text(item.title),
          );
        }).toList(),
        onChanged: (v) {
          onChanged.add(v);
        },
      );
    },
  );
}
