import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../widgets/transaction_list.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<TransactionModel> _expenses = [];
  final List<TransactionModel> _income = [];

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  bool _isExpense = true;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _isExpense = _tabController.index == 0;
      });
    });
    super.initState();
  }

  void _addTransaction() {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;

    if (title.isEmpty || amount <= 0) return;

    final tx = TransactionModel(title: title, amount: amount, date: '', type: '');
    setState(() {
      if (_isExpense) {
        _expenses.add(tx);
      } else {
        _income.add(tx);
      }
    });

    _titleController.clear();
    _amountController.clear();
    Navigator.pop(context); // Close the bottom sheet
  }

  void _showAddTransactionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _addTransaction,
                child: const Text('Add Transaction'),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Expenses'),
            Tab(text: 'Income'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TransactionList(transactions: _expenses),
          TransactionList(transactions: _income),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTransactionSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}
