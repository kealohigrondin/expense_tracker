// ignore_for_file: avoid_print

import 'package:expense_tracker/components/chart/chart.dart';
import 'package:expense_tracker/components/expense_modal.dart';
import 'package:expense_tracker/components/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: "Flutter Course",
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: "Groceries",
        amount: 50.32,
        date: DateTime.parse('2023-06-20'),
        category: Category.food)
  ];

  void _openAddExpenseModal() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) => ExpenseModal(onAddExpense: _addExpense),
        useSafeArea: true,
        isScrollControlled: true);
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    print('removing ${expense.title}');
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Expense Deleted'),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: "UNDO",
        onPressed: () {
          setState(() {
            _registeredExpenses.insert(expenseIndex, expense);
          });
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Expense Tracker"),
          actions: [
            IconButton(
                onPressed: _openAddExpenseModal, icon: const Icon(Icons.add))
          ],
        ),
        body: width < 600 //only show expense list if it isn't empty
            ? Column(
                children: [
                  Chart(expenses: _registeredExpenses),
                  _registeredExpenses.isNotEmpty
                      ? Expanded(
                          child: ExpenseList(
                              expenses: _registeredExpenses,
                              onRemoveExpense: _removeExpense))
                      : const Center(
                          child: Text('No expenses found, add some above.'),
                        )
                ],
              )
            : Row(
                children: [
                  Expanded(child: Chart(expenses: _registeredExpenses)),
                  _registeredExpenses.isNotEmpty
                      ? Expanded(
                          child: ExpenseList(
                              expenses: _registeredExpenses,
                              onRemoveExpense: _removeExpense))
                      : const Center(
                          child: Text('No expenses found, add some above.')),
                ],
              ));
  }
}
