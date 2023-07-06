import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:water_alarm/logic/hydration_pool_logic.dart';
import 'package:water_alarm/resources/assets.dart';

import 'package:water_alarm/ui/hydration_pool/hydration_quantity_text.dart';
import 'package:water_alarm/ui/hydration_pool/remaining_hydration_text.dart';
import 'package:water_alarm/ui/hydration_pool/water_view.dart';

class HydrationPoolPage extends StatefulWidget {
  @override
  _HydrationPoolPageState createState() => _HydrationPoolPageState();
}

class _HydrationPoolPageState extends State<HydrationPoolPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final HydrationPoolLogic _hydrationPoolLogic = HydrationPoolLogic();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  final bloc = context.watch<WaterBloc>();

    return ValueListenableBuilder(
        valueListenable: _hydrationPoolLogic.progressNotifier,
        builder: (context, value, child) {
          return Stack(
            children: [
              Align(
                alignment: const Alignment(0.0, -0.1),
                child: Lottie.asset(Assets.fishGif),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: WaterView(
                  animation: _controller,
                  progress: value,
                ),
              ),
              Align(
                alignment: const Alignment(0.0, -0.68),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HydrationQuantityText(
                        _hydrationPoolLogic.todayConsumptionAmount),
                    const SizedBox(height: 8),
                    RemainingHydrationText(
                        _hydrationPoolLogic.remindingWater()),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
