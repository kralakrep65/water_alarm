import 'package:flutter/material.dart';

import 'package:water_alarm/domain/model/water_input.dart';
import 'package:water_alarm/logic/hydration_pool_logic.dart';
import 'package:water_alarm/ui/hydration_progress/water_button.dart';

class WaterInputGroup extends StatelessWidget {
  WaterInputGroup({Key? key}) : super(key: key);
  final HydrationPoolLogic _hydrationPoolLogic = HydrationPoolLogic();

  @override
  Widget build(BuildContext context) {
    void addInput(WaterInput value) {
      _hydrationPoolLogic.setTodayConsumption(value.milliliters);
      // _hydrationPoolLogic.updateProgress();
      // context.read<WaterBloc>().drinkWater(value);
    }

    return Wrap(
      children: [
        WaterButton(
          input: WaterInput.small(),
          onPressed: addInput,
        ),
        WaterButton(
          input: WaterInput.regular(),
          onPressed: addInput,
        ),
        WaterButton(
          input: WaterInput.medium(),
          onPressed: addInput,
        ),
        WaterButton(
          input: WaterInput.large(),
          onPressed: addInput,
        ),
      ],
    );
  }
}
