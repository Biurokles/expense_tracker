import 'package:expense_tracker/provider/category/state/category_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:expense_tracker/data/models/category/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<String?> showCategoryDialog(
  BuildContext context, {
  Category? existing,
}) async {
  final titleController = TextEditingController(text: existing?.name ?? '');
  final maxAmountController = TextEditingController(
    text: existing?.maxAmount.toString() ?? '',
  );

  Color dialogColor = existing != null
      ? Color(existing.color)
      : const Color(0xff443a49);
  final formKey = GlobalKey<FormState>();

  Future<Color?> pickColor() async {
    Color tempColor = dialogColor;

    final colorResult = await showDialog<Color>(
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

    return colorResult;
  }

  final result = await showDialog<String>(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setStateDialog) {
          return AlertDialog(
            title: Text(
              existing == null ? 'Nowa kategoria' : 'Edytuj kategorię',
            ),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Nazwa kategorii',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Podaj nazwę';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: maxAmountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d*'),
                      ),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'I ile chcesz wydawać?',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Podaj cenę';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final picked = await pickColor();
                          if (picked != null) {
                            setStateDialog(() {
                              dialogColor = picked;
                            });
                          }
                        },
                        child: const Text('Kolorki'),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: dialogColor,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Nia'),
              ),
              Consumer(
                builder: (context, ref, child) {
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;

                          existing != null
                              ? ref
                                    .read(categoryProvider.notifier)
                                    .updateCategory(
                                      Category(
                                        id: existing.id,
                                        name: titleController.text,
                                        color: dialogColor.toARGB32(),
                                        maxAmount: double.parse(
                                          maxAmountController.text,
                                        ),
                                      ),
                                    )
                              : ref
                                    .read(categoryProvider.notifier)
                                    .addCategory(
                                      Category(
                                        name: titleController.text,
                                        color: dialogColor.toARGB32(),
                                        maxAmount: double.parse(
                                          maxAmountController.text,
                                        ),
                                      ),
                                    );
                          Navigator.pop(ctx, titleController.text);
                        },
                        child: const Text('Zapisz'),
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      );
    },
  );

  return result;
}
