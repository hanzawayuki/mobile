import 'package:flutter/material.dart';

void main() {
  // 最初に表示するWidget
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // アプリ名
      title: 'My Todo App',
      theme: ThemeData(
        // テーマカラー
        primarySwatch: Colors.blue,
      ),
      // リスト一覧画面を表示
      home: TodoListPage(),
    );
  }
}

class TodoListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '金銭管理アプリ',
          style: TextStyle(fontSize: 70),
        ),
      ),
      floatingActionButton: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return TodoAddPage();
              }),
            );
          },
          child: Text("スタート"),
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 30),
            foregroundColor: Colors.white, // foreground
            fixedSize: Size(220, 80),
            alignment: Alignment.topCenter,
          )),

      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return TodoAddPage();
            }),
          );
        },
        child: Icon(Icons.add),
      ),*/
    );
  }
}

// リスト追加画面用Widget
class TodoAddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          // ボタンをクリックした時の処理
          onPressed: () {
            // "pop"で前の画面に戻る
            Navigator.of(context).pop();
          },
          child: Text('Top画面に戻る'),
        ),
      ),
    );
  }
}
