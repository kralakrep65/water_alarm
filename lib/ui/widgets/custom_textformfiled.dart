import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {Key? key,
      required this.textController,
      required this.labelText,
      required this.hintText,
      this.textValidator,
      this.inputType})
      : super(key: key);
  final String labelText;
  final String hintText;
  final String? Function(String?)? textValidator;
  final TextInputType? inputType;
  final TextEditingController textController;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      keyboardType: inputType,
      style: const TextStyle(
          fontSize: 16, color: Color(0xffCE643A), fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        hintStyle: const TextStyle(fontSize: 16, color: Color(0xffCE643A)),
        labelStyle: const TextStyle(fontSize: 16, color: Color(0xffCE643A)),
        labelText: labelText,
        errorStyle: const TextStyle(color: Colors.red),
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      validator: textValidator,
    );
  }
}
