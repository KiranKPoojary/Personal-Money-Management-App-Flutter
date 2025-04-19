import 'package:flutter/material.dart';
import 'package:personal_money_management_app/db/transaction_db.dart';
import '../models/transaction.dart';


class TransactionList extends StatelessWidget {
  final List<TransactionModel> transactions;

  const TransactionList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? const Center(child: Text('No transactions added yet!'))
        : ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (ctx, index) {
        final tx = transactions[index];
        return ListTile(
          title: Text(tx.title),
          subtitle: Text('\$${tx.amount.toStringAsFixed(2)}'),

        );
      },
    );
  }
}
