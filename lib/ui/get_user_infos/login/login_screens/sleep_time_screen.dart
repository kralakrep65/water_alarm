import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:water_alarm/constant/size_config.dart';
import 'package:water_alarm/resources/assets.dart';

class SleepTimeScreen extends StatelessWidget {
  final Function(DateTime w) setSleepTime;
  const SleepTimeScreen({super.key, required this.setSleepTime});
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
                    initialDateTime:
                        DateTime.now().add(const Duration(hours: 8)),
                    onDateTimeChanged: setSleepTime),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
