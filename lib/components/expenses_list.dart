import 'package:expense_tracker/components/expense_item.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList(
      {required this.expenses, required this.onRemoveExpense, super.key});
  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (ctx, index) => Dismissible(
              onDismissed: (direction) {
                onRemoveExpense(expenses[index]);
              },
              key: UniqueKey(),
              child: ExpenseItem(expense: expenses[index]),
            ));
  }
}
