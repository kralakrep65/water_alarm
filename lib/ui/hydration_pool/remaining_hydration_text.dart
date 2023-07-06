import 'package:flutter/material.dart';
import 'package:water_alarm/util/num_extension.dart';

class RemainingHydrationText extends StatelessWidget {
  final double quantity;

  const RemainingHydrationText(this.quantity, {super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1500),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: const Interval(0.8, 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: Text(
          "${quantity < 0 ? '+' : 'Remaining '}${quantity.abs().asMilliliters()}"),
    );
  }
}
