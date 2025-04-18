import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'transaction_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = DBHelper();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  String type = "expense";

  List<TransactionModel> transactions = [];

  void loadData() async {
    final data = await db.getTransactions();
    setState(() {
      transactions = data.map((e) => TransactionModel.fromMap(e)).toList();
    });
  }

  void addTransaction() async {
    TransactionModel tx = TransactionModel(
      title: titleController.text,
      amount: double.parse(amountController.text),
      date: DateTime.now().toString(),
      type: type,
    );
    await db.insertTransaction(tx.toMap());
    titleController.clear();
    amountController.clear();
    loadData();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Finance")),
      body: Column(
        children: [
          TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
          TextField(controller: amountController, decoration: InputDecoration(labelText: "Amount"), keyboardType: TextInputType.number),
          DropdownButton(
            value: type,
            items: ['income', 'expense']
                .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                .toList(),
            onChanged: (val) => setState(() => type = val!),
          ),
          ElevatedButton(onPressed: addTransaction, child: Text("Add")),
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (_, i) {
                final tx = transactions[i];
                return ListTile(
                  title: Text(tx.title),
                  subtitle: Text(tx.date),
                  trailing: Text("₹ ${tx.amount} (${tx.type})"),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
