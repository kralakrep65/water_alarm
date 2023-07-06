import 'package:flutter/material.dart';

class ItemHorizontalPadding extends StatelessWidget {
  const ItemHorizontalPadding({Key? key, this.padding, required this.child})
      : super(key: key);
  final double? padding;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding ?? 16),
      child: child,
    );
  }
}
