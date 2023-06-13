// ignore_for_file: avoid_print

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class ExpenseModal extends StatefulWidget {
  const ExpenseModal({required this.onAddExpense, super.key});

  final void Function(Expense expense) onAddExpense;
  @override
  State<ExpenseModal> createState() => _ExpenseModalState();
}

class _ExpenseModalState extends State<ExpenseModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.work;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(now.year - 1, now.month, now.day),
        lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    if (_titleController.text.trim().isEmpty ||
        enteredAmount == null ||
        enteredAmount <= 0 ||
        _selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Invalid Input'),
                content: const Text('Please validate all fields are correct'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text('Close'))
                ],
              ));
    } //end if
    widget.onAddExpense(Expense(
        title: _titleController.text.trim(),
        amount: enteredAmount!,
        date: _selectedDate!,
        category: _selectedCategory));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    var nameField = TextField(
      maxLength: 50,
      decoration: const InputDecoration(label: Text('Expense Name')),
      controller: _titleController,
    );
    var amountField = TextField(
      keyboardType: TextInputType.number,
      maxLength: 50,
      decoration:
          const InputDecoration(label: Text('Amount'), prefixText: '\$'),
      controller: _amountController,
    );
    var datePicker = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(_selectedDate == null
            ? 'Select Date'
            : formatter.format(_selectedDate!)),
        IconButton(
            onPressed: _presentDatePicker,
            icon: const Icon(Icons.calendar_month))
      ],
    );
    var categoryDropdown = DropdownButton(
        value: _selectedCategory,
        items: Category.values
            .map((category) => DropdownMenuItem(
                value: category,
                child: Text(category.name.toString().toUpperCase())))
            .toList(),
        onChanged: (value) {
          print(value);
          if (value == null) {
            return;
          }
          setState(() {
            _selectedCategory = value;
          });
        });
    var navigationRow = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
        const SizedBox(width: 10),
        ElevatedButton(
            onPressed: _submitExpenseData, child: const Text('Save Expense'))
      ],
    );




    var portraitExpenseModal = Column(
      children: [
        nameField,
        Row(
          children: [
            Expanded(child: amountField),
            Expanded(child: datePicker),
          ],
        ),
        Row(children: [categoryDropdown]),
        navigationRow
      ],
    );

    var landscapeExpenseModal = Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: nameField),
            const SizedBox(width: 10),
            Expanded(child: amountField),
          ],
        ),
        Row(
          children: [
            categoryDropdown,
            Expanded(child: datePicker),
          ],
        ),
        navigationRow
      ],
    );






    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.fromLTRB(12, 8, 12, keyboardHeight + 4),
              child:
                  width <= 600 ? portraitExpenseModal : landscapeExpenseModal),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _amountController.dispose();
  }
}
