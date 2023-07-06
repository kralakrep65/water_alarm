import 'package:flutter/material.dart';
import 'package:water_alarm/constant/size_config.dart';
import 'package:water_alarm/resources/assets.dart';
import 'package:water_alarm/ui/get_user_infos/login/login_screens/widget/custom_data_picker.dart';

class HeightPage extends StatelessWidget {
  final Function(int h) setHeight;
  HeightPage({super.key, required this.setHeight});
  final List<String> stringList = [];
  fillList() {
    stringList.clear();
    for (int i = 20; i < 250; i++) {
      stringList.add(i.toString());
    }
  }

  final int initialIndex = 150;
  @override
  Widget build(BuildContext context) {
    fillList();
    return Row(
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
                setHeight(int.parse(value));
              },
            ),
          ),
        ),
      ],
    );
  }
}
