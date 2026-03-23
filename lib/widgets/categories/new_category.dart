import 'package:expense_tracker/services/category_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class NewCategory extends StatefulWidget {
  const NewCategory({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewCategoryState();
  }
}

class _NewCategoryState extends State<NewCategory> {
  Color currentColor = Color(0xff443a49);
  Color pickerColor = Color(0xff443a49);

  void pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: changeColor,
          ),

          // Use Material color picker:
          //
          // child: MaterialPicker(
          //   pickerColor: pickerColor,
          //   onColorChanged: changeColor,
          //   showLabel: true, // only on portrait mode
          // ),
          //
          // Use Block color picker:
          //
          // child: BlockPicker(
          //   pickerColor: currentColor,
          //   onColorChanged: changeColor,
          // ),
          //
          // child: MultipleChoiceBlockPicker(
          //   pickerColors: currentColors,
          //   onColorsChanged: changeColors,
          // ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Juuuż'),
            onPressed: () {
              setState(() => currentColor = pickerColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  final _amountController = TextEditingController();
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _titleController,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('i na co tym razem chcesz wydawać nasze pieniążki'),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: _amountController,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                  ],
                  decoration: const InputDecoration(
                    prefixText: 'polskich złociszy  ',
                    label: Text(
                      'Ile chcesz wydawać w miesiącu na tą kategorie?',
                    ),
                  ),
                ),
              ),
            ],
          ),

          Row(
            children: [
              ElevatedButton(
                onPressed: pickColor,
                child: Text('Kolorki'),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: currentColor,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                child: Text('Zaaapiiisz'),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _amountController.clear();
                  _titleController.clear();
                },
                child: Text('Nie Zapisuuuj'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
