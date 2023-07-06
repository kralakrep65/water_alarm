import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCupertinoDatePicker extends StatelessWidget {
  final List<String> stringList;
  final int initialIndex;
  final ValueChanged<String> onDateChanged;

  const CustomCupertinoDatePicker({
    super.key,
    required this.stringList,
    required this.initialIndex,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: initialIndex),
      itemExtent: 25.0,
      onSelectedItemChanged: (int index) {
        onDateChanged(stringList[index]);
      },
      children: stringList.map((String dateString) {
        return Text(
          dateString,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20.0, color: Colors.blue),
        );
      }).toList(),
    );
  }
}
