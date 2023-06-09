import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid_type/uuid_type.dart';

final formatter = DateFormat.yMd();

enum Category { food, travel, leisure, work }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work
};

class Expense {
  Expense(
      {required this.title,
      required this.amount,
      required this.date,
      required this.category})
      : id = RandomUuidGenerator().generate();

  final Uuid id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenseList});

  //alternative constructor method, builds an expenseBucket for a given category
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenseList = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenseList;

  double get totalExpenses {
    double sum = 0;
    for (final Expense e in expenseList) {
      sum += e.amount;
    }
    return sum;
  }
}
