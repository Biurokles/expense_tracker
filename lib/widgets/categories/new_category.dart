import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/services/category_storage.dart';
import 'package:expense_tracker/services/expense_storage.dart';
import 'package:expense_tracker/widgets/categories/categories_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'category_dialog.dart';

class NewCategory extends StatefulWidget {
  const NewCategory({
    super.key,
    required this.onAddCategory,
    required this.onDismissedCategory,
  });

  final void Function(Category category) onAddCategory;
  final Future<bool> Function(Category category) onDismissedCategory;
  @override
  State<StatefulWidget> createState() {
    return _NewCategoryState();
  }
}

class _NewCategoryState extends State<NewCategory> {
  Color currentColor = Color(0xff443a49);
  Color pickerColor = Color.fromRGBO(68, 58, 73, 1);
  List<Expense> _registeredExpenses = [];

  @override
  void initState() {
    super.initState();

    ExpenseStorage.load().then((loadedExpenses) {
      setState(() {
        _registeredExpenses = loadedExpenses;
      });
    });

    CategoryStorage.load().then((loadedCategories) {
      setState(() {
        _registeredCategories = loadedCategories;
      });
    });
  }

  List<Category> _registeredCategories = [];

  Future<Color?> pickColor() async {
    Color tempColor = pickerColor;

    final result = await showDialog<Color>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: tempColor,
              onColorChanged: (color) {
                tempColor = color;
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Juuuż'),
              onPressed: () {
                Navigator.of(context).pop(tempColor);
              },
            ),
          ],
        );
      },
    );

    return result;
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void _openDialog({Category? existing}) async {
    final result = await showCategoryDialog(context, existing: existing);

    if (result != null) {
      widget.onAddCategory(result);

      final loadedCategories = await CategoryStorage.load();
      setState(() {
        _registeredCategories = loadedCategories;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(16, 48, 16, 16),

      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: _openDialog,
              icon: const Icon(Icons.add),
            ),
            SizedBox(
              height: 10,
            ),
            if (_registeredCategories.isNotEmpty)
              Expanded(
                child: CategoriesList(
                  expenses: _registeredExpenses,
                  categories: _registeredCategories,
                  onRemoveCategory: widget.onDismissedCategory,
                  onClickCategory: _openDialog,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
