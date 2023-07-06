import 'package:flutter/material.dart';
import 'package:water_alarm/resources/assets.dart';
import 'package:water_alarm/ui/get_user_infos/login/login_screens/widget/gender_avatar.dart';

class GenderPage extends StatefulWidget {
  const GenderPage({super.key, required this.setGender});
  final Function(int) setGender;
  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  int gender = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
            onTap: () {
              widget.setGender(1);
              setState(() {
                gender = 0;
              });
            },
            child: GenderAvatar(
                assetsImage: Assets.boyAvatar,
                genderName: "Man",
                isSelected: gender == 0)),
        GestureDetector(
            onTap: () {
              widget.setGender(0);

              setState(() {
                gender = 1;
              });
            },
            child: GenderAvatar(
                assetsImage: Assets.girlAvatar,
                genderName: "Woman",
                isSelected: gender == 1)),
      ],
    );
  }
}
