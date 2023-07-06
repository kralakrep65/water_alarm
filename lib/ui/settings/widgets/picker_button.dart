import 'package:flutter/material.dart';

class CustomPickerButton extends StatelessWidget {
  const CustomPickerButton({
    Key? key,
    required this.onPressed,
    this.title,
  }) : super(key: key);
  final VoidCallback onPressed;
  final String? title;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xffCE643A))),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            title ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Color(0xffCE643A)),
          ),
        ),
      ),
    );
  }
}
