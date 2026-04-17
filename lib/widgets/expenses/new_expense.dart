import 'package:expense_tracker/provider/category/state/category_notifier.dart';
import 'package:expense_tracker/provider/expense/state/expense_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:expense_tracker/data/models/expense/expense.dart";
import 'package:expense_tracker/data/models/category/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../categories/category_dialog.dart';

class NewExpense extends ConsumerStatefulWidget {
  const NewExpense({super.key});

  @override
  ConsumerState<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends ConsumerState<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  Category? _selectedCategory;
  DateTime? _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final categoriesAsync = ref.read(categoryProvider);

      categoriesAsync.whenData((categories) {
        if (categories.isEmpty) return;

        if (_selectedCategory == null) {
          setState(() {
            _selectedCategory = categories.first;
          });
        }
      });
    });
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: firstDate,
      lastDate: now,
    );

    if (pickedDate == null) return;

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);

    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    final titleIsInvalid = _titleController.text.trim().isEmpty;

    if (titleIsInvalid ||
        amountIsInvalid ||
        _selectedDate == null ||
        _selectedCategory == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('womp womp'),
          content: const Text('Łiła! nie tak wpisałaś! Poprawo to'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("dobsie dobsie"),
            ),
          ],
        ),
      );
      return;
    }

    ref
        .read(expenseProvider.notifier)
        .addExpense(
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
    final categoryState = ref.watch(categoryProvider);
    late final newCategoryStatus;
    ref.listen(categoryProvider, (
      previous,
      next,
    ) {
      final category = next.value!.firstWhere(
        (e) => newCategoryStatus.toString() == e.name,
      );
      setState(() {
        _selectedCategory = category;
      });
    });

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(
              labelText: 'Na co wydałaś pieniądze?',
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
                    prefixText: 'Polskich złociszy ',
                    labelText: 'Ile?',
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Text(
                _selectedDate == null
                    ? 'Wybierz datę'
                    : formatter.format(_selectedDate!),
              ),

              IconButton(
                onPressed: _presentDatePicker,
                icon: const Icon(Icons.calendar_month),
              ),
            ],
          ),

          const SizedBox(height: 16),

          categoryState.when(
            data: (categories) {
              if (_selectedCategory == null && categories.isNotEmpty) {
                _selectedCategory = categories.first;
              }

              return Row(
                children: [
                  if (categories.isEmpty)
                    const Text("Brak kategorii")
                  else
                    DropdownButton<Category>(
                      value: _selectedCategory,
                      hint: const Text("Wybierz kategorię"),
                      items: categories
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(c.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),

                  const Spacer(),

                  ElevatedButton(
                    onPressed: _selectedCategory != null
                        ? _submitExpenseData
                        : null,
                    child: const Text('Zapisz'),
                  ),
                ],
              );
            },

            loading: () => const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),

            error: (e, _) => Text('Error: $e'),
          ),

          const SizedBox(height: 8),
          IconButton(
            onPressed: () async {
              newCategoryStatus = await showCategoryDialog(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
