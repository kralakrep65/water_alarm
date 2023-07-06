import 'dart:math';

import 'package:flutter/material.dart';
import 'package:water_alarm/domain/repository/person_repository.dart';
import 'package:water_alarm/logic/hydration_pool_logic.dart';

import 'package:water_alarm/ui/hydration_progress/progress_painter.dart';

class ProgressView extends StatelessWidget {
  final HydrationPoolLogic _hydrationPoolLogic = HydrationPoolLogic();

  ProgressView({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = SweepGradient(
      transform: const GradientRotation(pi * 3 / 2),
      colors: [
        theme.colorScheme.secondary.withOpacity(0.5),
        theme.colorScheme.secondary.withOpacity(0.5),
      ],
    );

    return ValueListenableBuilder(
        valueListenable: _hydrationPoolLogic.progressNotifier,
        builder: (context, value, child) {
          return TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            // tween: Tween(begin: 0.0, end: bloc.progress),
            tween: Tween(begin: 0.0, end: value),
            builder: (context, value, child) {
              return CustomPaint(
                painter: ProgressPainter(
                  gradient: gradient,
                  inactiveColor: theme.unselectedWidgetColor,
                  progress: value.clamp(0.0, 1.0),
                ),
                child: _DataColumn(progress: value),
              );
            },
          );
        });
  }
}

class _DataColumn extends StatelessWidget {
  final double progress;
  PersonRepository get _personRepository => PersonRepository();
  int count = 0;
  getConsumptionCount() async {
    countNotifier.value = await _personRepository.getConsumptionCount();
  }

  ValueNotifier<int> countNotifier = ValueNotifier<int>(0);
  _DataColumn({
    Key? key,
    required this.progress,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    getConsumptionCount();
    final theme = Theme.of(context);

    return ValueListenableBuilder(
        valueListenable: countNotifier,
        builder: (context, value, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: double.infinity),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "${(progress * 100).toInt()} %",
                  maxLines: 3,
                  style: theme.textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value.toString(),
                style: theme.textTheme.bodyText1,
              ),
              const SizedBox(height: 8),
              Text(
                (value + 1).toString(),
                style: theme.textTheme.caption,
              ),
            ],
          );
        });
  }
}
