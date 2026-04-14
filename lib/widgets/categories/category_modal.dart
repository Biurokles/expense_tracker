import 'package:expense_tracker/provider/category/state/category_notifier.dart';
import 'package:expense_tracker/widgets/categories/categories_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'category_dialog.dart';

class CategoryModal extends ConsumerStatefulWidget {
  const CategoryModal({
    super.key,
  });

  @override
  ConsumerState<CategoryModal> createState() {
    return _CategoryModalState();
  }
}

class _CategoryModalState extends ConsumerState<CategoryModal> {
  Color currentColor = Color(0xff443a49);
  Color pickerColor = Color.fromRGBO(68, 58, 73, 1);

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

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                showCategoryDialog(context);
              },
              icon: const Icon(Icons.add),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: categoryState.when(
                data: (categories) {
                  if (categories.isEmpty) {
                    return const Center(
                      child: Text("Brak kategorii"),
                    );
                  }

                  return CategoriesList(categories: categories);
                },

                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),

                error: (e, _) => Center(
                  child: Text("Error: $e"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
