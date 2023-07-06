import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final Color? color;
  final Color? textColor;
  const PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.title,
    this.color,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all(color ?? theme.primaryColor),
        padding:
            MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          title,
          style: TextStyle(
              fontSize: 16,
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
