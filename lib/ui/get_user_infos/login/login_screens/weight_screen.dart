import 'package:flutter/material.dart';
import 'package:water_alarm/constant/size_config.dart';
import 'package:water_alarm/resources/assets.dart';
import 'package:water_alarm/ui/get_user_infos/login/login_screens/widget/custom_data_picker.dart';

class WeightScreen extends StatelessWidget {
  final Function(int w) setWeight;
  WeightScreen({super.key, required this.setWeight});
  final List<String> stringList = [];
  fillList() {
    stringList.clear();
    for (int i = 20; i < 200; i++) {
      stringList.add(i.toString());
    }
  }

  final int initialIndex = 40;
  @override
  Widget build(BuildContext context) {
    fillList();
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Image.asset(
              Assets.standBoy,
            ),
          ),
          Expanded(
            child: SizedBox(
              height: sizeConfig.heightSize(context, 200),
              child: CustomCupertinoDatePicker(
                stringList: stringList,
                initialIndex: initialIndex,
                onDateChanged: (value) {
                  setWeight(int.parse(value));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
