//
// video_bloc.dart
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
import 'package:meta/meta.dart';
import 'package:mob_conf_video/common/hot_observables_holder.dart';
import 'package:rxdart/rxdart.dart';

class Conference {
  Conference({
    @required this.id,
    @required this.name,
    @required this.starts,
  });

  final String id;
  final String name;
  final DateTime starts;
}

class Session {
  Session({
    @required this.id,
    @required this.conferenceId,
    @required this.conferenceName,
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
  final String conferenceName;
  final String title;
  final String description;
  final DateTime starts;
  final int minutes;
  final String slide;
  final String video;
  final List<Speaker> speakers;
}

class Speaker {
  Speaker({
    @required this.name,
    @required this.twitter,
    @required this.icon,
  });

  final String name;
  final String twitter;
  final String icon;
}

abstract class VideoBloc implements Bloc {
  // inputs

  // outputs
  Stream<List<Session>> get sessions;
}

class DefaultVideoBloc implements VideoBloc {
  Stream<List<Session>> get sessions => _sessions;

  final _hotObservablesHolder = HotObservablesHolder();
  Observable<List<Session>> _sessions;

  DefaultVideoBloc() {
    _sessions = _hotObservablesHolder.replayConnect(Observable.just([
      Session(
        id: "iOSDC2018_229db830-848e-4496-b863-46f8ba690c5d",
        conferenceId: "iOSDC2018",
        conferenceName: "iOSDC Japan 2018",
        title: "全部iOSにしゃべらせちゃえ！",
        description:
            "いっけなーい💦トークトーク🗣私、ひろん。今年もiOSDCのLTに応募したの✨でもiOSDCは競技LT🏅オーディエンスもいっぱいいるから緊張してしゃべれないよー🙀あ、そうだ💡AVSpeechSynthesizerちゃんとPDF Kitくんに頼めば、代わりに発表してくれるんじゃない？💕私あったまいいー…って本当に採択されたらどうしよう🆘次回「全部iOSにしゃべらせちゃえ！」お楽しみに",
        starts: DateTime.parse("2018-09-02T16:05:00+09:00"),
        minutes: 5,
        slide: "https://speakerdeck.com/hironytic/iosdc-2018-lt",
        video: "https://www.youtube.com/watch?v=bbKroWHw3dY",
        speakers: [
          Speaker(
            name: "ひろん",
            twitter: "hironytic",
            icon:
                "https://fortee.jp/files/iosdc-japan-2018/speaker/20bbb736-e03d-4004-8165-ec39a690bd8f.jpg",
          ),
        ],
      ),
      Session(
        id: "DroidKaigi2018_16969",
        conferenceId: "DroidKaigi2018",
        conferenceName: "DroidKaigi 2018",
        title: "Kotlinアンチパターン",
        description:
            "　KotlinはJavaよりもシンプルで安全なコードを書くことができます。また、同じ処理を書く場合も、いくつかのやり方があります。文法に関する説明は、公式ドキュメントを見れば分かりますが、使いどころ、特にAndroidアプリ開発における使いどころについては、まだそれぞれ模索している段階といってよいのではないでしょうか。\r\n　このセッションでは、私がフルKotlinのアプリをチームで開発した経験の中で分かった、Kotlinの各種文法の適切な使いどころや、バグを生みやすいコードのパターンなどを紹介してみたいと思います。\r\n　例えば、lateinitとnull初期化の使い分け、interfaceのデフォルト実装とabstractクラスの使い分け、引数なしの関数とcustom getterの使い分け、定数とlazyとcustom getterの使い分けなどがあります。また、property delegationの使いどころ、スコープ関数の使いどころ、レシーバー付き関数型の使いどころなど、Kotlinの基本文法を紹介しつつ、Androidアプリ開発をした経験からActivityライフサイクルやFragmentライフサイクルに合わせた使いどころ・注意点などについて解説してみたいと思います。",
        starts: DateTime.parse("2018-02-08T10:20:00+09:00"),
        minutes: 30,
        slide: "https://www.slideshare.net/RecruitLifestyle/kotlin-87339759",
        video: "https://www.youtube.com/watch?v=TmG2YabAyFk",
        speakers: [
          Speaker(
            name: "Naoto Nakazato",
            twitter: null,
            icon:
                "https://sessionize.com/image?f=6f258c127bde2ff43ae84d2164e2d4b7,200,200,True,False,db7440c9-9763-459e-bfe7-687079885ccd.jpg",
          ),
        ],
      ),
    ]));
  }

  void dispose() {
    _hotObservablesHolder.dispose();
  }
}
