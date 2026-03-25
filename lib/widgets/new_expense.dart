import 'package:expense_tracker/services/category_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:expense_tracker/models/expense.dart";
import 'package:expense_tracker/models/category.dart';
import 'categories/category_dialog.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({
    super.key,
    required this.onAddExpense,
    required this.onAddCategory,
  });

  final void Function(Expense expense) onAddExpense;
  final void Function(Category category) onAddCategory;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

@override
void initState() {
  super.initState();
  loadAll();
}

Future<void> loadAll() async {
  final loadedCategories = await CategoryStorage.load();

  setState(() {
    _registeredCategories = loadedCategories;

    // 🔥 ustaw domyślną kategorię PO załadowaniu
    if (_selectedCategory == null && loadedCategories.isNotEmpty) {
      _selectedCategory = loadedCategories[0];
    }
  });
}

  Category? _selectedCategory;
  DateTime? _selectedDate;
  List<Category> _registeredCategories = [];

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

void _openDialog({Category? existing}) async {
  final result = await showCategoryDialog(context, existing: existing);

  if (result != null) {
    widget.onAddCategory(result);

    final loadedCategories = await CategoryStorage.load();

    setState(() {
      _registeredCategories = loadedCategories;

      _selectedCategory = loadedCategories.firstWhere(
        (c) => c.id == result.id,
        orElse: () => loadedCategories.first,
      );
    });
  }
}

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);

    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    final titleIsInvalid = _titleController.text.trim().isEmpty;

    if (titleIsInvalid || amountIsInvalid || _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('womp womp'),
          content: const Text(
            'Łiła! Wpisałaś nie tak jak trzeba, popraw to dobsie?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("dobsie dobsie"),
            ),
          ],
        ),
      );
      return;
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory!,
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('i na co tym razem wydałaś nasze pieniążki'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                  ],
                  decoration: const InputDecoration(
                    prefixText: 'polskich złociszy  ',
                    label: Text('ILEEE??'),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'i kieeedyyy'
                          : formatter.format(_selectedDate!),
                    ),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _selectedCategory == null
                  ? Text("Łiła, nie ma tu żadnych kategorii")
                  : DropdownButton(
                      value: _selectedCategory,
                      items: _registeredCategories
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(
                                category.name,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          if (value == null) {
                            return;
                          } else {
                            _selectedCategory = value;
                          }
                        });
                      },
                    ),
              const Spacer(),
              ElevatedButton(
                onPressed: _selectedCategory != null
                    ? _submitExpenseData
                    : null,
                child: Text('Zapisz'),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: _selectedCategory != null
                    ? () {
                        Navigator.pop(context);
                        _amountController.clear();
                        _titleController.clear();
                      }
                    : null,
                child: Text('Nia'),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                height: 10,
              ),
              IconButton(
                onPressed: _openDialog,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
