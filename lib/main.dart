import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/models/history.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(HistoryAdapter());

  await Hive.openBox<History>('history');

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
        title: Text('トップページ'),
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

  String? amount;

  Future<void> saveAmount(BuildContext context) async {
    String amount = amountController.text;

    amountController.clear();

    final box = await Hive.openBox<History>('history');

    final history =
        History(amount: amount != null && amount.isNotEmpty ? amount! : '');

    box.add(history);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryPage(history: history),
        settings: RouteSettings(arguments: amount),
      ),
    );

    // await Future.delayed(Duration.zero);
    // print('Before navigating to history page');
    // await Navigator.push(context, route);
    // print('After navigating to history page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('金額保存画面'),
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
              onPressed: () async {
                await saveAmount(context);
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

class HistoryPage extends StatefulWidget {
  final History? history;

  HistoryPage({this.history});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> historyList = [];

  @override
  void initState() {
    super.initState();
    loadHistoryList();
  }

  void loadHistoryList() async {
    var box = await Hive.openBox<History>('history');
    setState(() {
      historyList = box.values.map((e) => e.amount ?? '').toList();
    });
  }

  void deleteHistory(int index) {
    final box = Hive.box<History>('history');
    box.deleteAt(index);
    setState(() {
      historyList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('金額履歴ページ'),
      ),
      body: Column(
        children: [
          Text('保持された金額: ${widget.history?.amount ?? ''}'),
          Expanded(
            child: ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final historyAmount = historyList[index];
                return ListTile(
                  title: Text(historyAmount),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteHistory(index);
                    },
                  ),
                );
              },
            ),
          ),
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
  final String amount;

  History({required this.amount});
}
