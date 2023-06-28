import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/models/history.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(HistoryAdapter());
  runApp(
    MaterialApp(home: MoneyManagerApp()),
  );
}

class MoneyManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Manager',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        '/': (context) => TopPage(),
        '/moneyManager': (context) => HomePage(),
        '/history': (context) => HistoryPage(history: History(amount: '')),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '金銭管理アプリ',
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/moneyManager');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                textStyle: TextStyle(fontSize: 60.0),
                primary: Colors.green,
              ),
              child: Text('スタート！'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController amountController = TextEditingController();
  List<String> history = [];

  void saveAmount(BuildContext context) async {
    String amount = amountController.text;

    amountController.clear();

    final box = await Hive.openBox<History>('history');

    // History オブジェクトを作成し、データを設定します
    final history = History(amount: amount);

    // データを Hive ボックスに保存します
    box.add(history);

    final route = MaterialPageRoute(
      builder: (context) => HistoryPage(history: history),
      settings: RouteSettings(arguments: amount),
    );

    await Future.delayed(Duration.zero); // ミリ秒単位で非同期のギャップを作成します

    await Navigator.push(context, route);

    //   await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => HistoryPage(history: history),
    //       settings: RouteSettings(arguments: amount),
    //     ),
    //   );
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
              onPressed: () {
                saveAmount(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                textStyle: TextStyle(fontSize: 35.0),
                primary: Colors.green,
              ),
              child: Text('保存'),
            ),
            SizedBox(height: 35.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/history');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                textStyle: TextStyle(fontSize: 35.0),
                primary: Colors.green,
              ),
              child: Text('金額履歴を表示'),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  final History? history;

  HistoryPage({this.history});

  void deleteHistory(int index) {
    final box = Hive.box<History>('history');
    box.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    final String? amount =
        ModalRoute.of(context)?.settings.arguments as String?;

    // History オブジェクトをリストに変換する
    final List<String> historyList = [history?.amount ?? '']; // 適宜変更する必要があります

    return Scaffold(
      appBar: AppBar(
        title: Text('金額履歴ページ'),
      ),
      body: Column(
        children: [
          Text('保持された金額: ${history?.amount ?? ''}'),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('戻る'),
          ),
        ],
      ),
    );
  }
}

class History {
  late String amount; // 金額を保持するプロパティ

  History({required this.amount}); // コンストラクタで金額を受け取って初期化
}
