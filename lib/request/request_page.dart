import 'package:flutter/material.dart';

class RequestPage extends StatefulWidget {
  RequestPage({Key key, this.bottomNavigationBar}) : super(key: key);

  final Widget bottomNavigationBar;

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        title: Text("リクエスト"),
          title: PopupMenuButton(
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<int>>[
              const PopupMenuItem(value: 0, child: Text("第2回 カンファレンス動画鑑賞会")),
              const PopupMenuItem(value: 1, child: Text("第1回 カンファレンス動画鑑賞会")),
              const PopupMenuItem(value: 1, child: Text("第0回 カンファレンス動画鑑賞会")),
            ],
            child: Text("第0回 カンファレンス動画鑑賞会 \u25be"),
          )
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("スマホアプリエンジニアだから知ってほしいブロックチェーンと分散型アプリケーション"),
            subtitle: Text("iOSDC Japan 2018"),
            trailing: Icon(Icons.check),
          ),
          Divider(),
          ListTile(
            title: Text("DDD(ドメイン駆動設計)を知っていますか？？"),
            subtitle: Text("iOSDC 2018 Reject Conference"),
            trailing: Icon(Icons.check),
          ),
          Divider(),
          ListTile(
            title: Text("再利用可能なUI Componentsを利用したアプリ開発"),
            subtitle: Text("iOSDC Japan 2018"),
            trailing: null,
          ),
          Divider(),
        ],
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
