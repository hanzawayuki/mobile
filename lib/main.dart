import 'package:flutter/material.dart';

void main() {
  runApp(MoneyManagerApp());
}

class MoneyManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => TopPage(),
        '/moneyManager': (context) => HomePage(),
      },
      initialRoute: '/',
    );
  }
}

class TopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/moneyManager');
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            textStyle: TextStyle(fontSize: 24.0),
            primary: Colors.red,
          ),
          child: Text('Open Money Manager'),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  TextEditingController amountController = TextEditingController();

  void saveAmount(BuildContext context) {
    String amount = amountController.text;
    // ここに金額の保存ロジックを追加する

    // 保存が完了したら、テキストフィールドをクリアする
    amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '金額を入力してください',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => saveAmount(context),
              child: Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
