import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:water_alarm/constant/size_config.dart';
import 'package:water_alarm/resources/assets.dart';

class WakeUpPage extends StatelessWidget {
  final Function(DateTime w) setWekaUp;
  const WakeUpPage({super.key, required this.setWekaUp});

  final int initialIndex = 45;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Image.asset(
              Assets.wakeUp,
            ),
          ),
          Expanded(
            child: SizedBox(
              height: sizeConfig.heightSize(context, 200),
              child: CupertinoPopupSurface(
                isSurfacePainted: true,
                child: CupertinoDatePicker(
                  backgroundColor: Colors.white,
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: setWekaUp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
