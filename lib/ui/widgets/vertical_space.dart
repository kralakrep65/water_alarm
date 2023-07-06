import 'package:flutter/material.dart';
import 'package:water_alarm/constant/size_config.dart';

class VerticalSpace extends StatelessWidget {
  const VerticalSpace({Key? key, required this.height}) : super(key: key);
  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: sizeConfig.heightSize(context, height));
  }
}
