import 'package:flutter/material.dart';
import 'package:water_alarm/ui/get_user_infos/login/login_page_builder.dart';
import 'package:water_alarm/ui/get_user_infos/login/login_screens/widget/pentagon_custom_painter.dart';

class TopPeriodWidget extends StatelessWidget {
  const TopPeriodWidget(
      {super.key, required this.assetList, required this.currentIndex});
  final double height = 15;
  final double width = 30;
  final int currentIndex;
  final List<AssetsModel> assetList;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomPaint(
          painter: PentagonPainter(Colors.blue, currentIndex == 0),
          size: Size(width, height),
          child: Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 5, top: 5),
            child: Image.asset(
              assetList[0].iconPath,
              height: height,
              width: width,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          color: Colors.blue,
          width: 30,
          height: 1,
        ),
        CustomPaint(
          painter: PentagonPainter(Colors.blue, currentIndex == 1),
          size: Size(width, height),
          child: Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 5, top: 5),
            child: Image.asset(
              assetList[1].iconPath,
              height: height,
              width: width,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          color: Colors.blue,
          width: 30,
          height: 1,
        ),
        CustomPaint(
          painter: PentagonPainter(Colors.blue, currentIndex == 2),
          size: Size(width, height),
          child: Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 5, top: 5),
            child: Image.asset(
              assetList[2].iconPath,
              height: height,
              width: width,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          color: Colors.blue,
          width: 30,
          height: 1,
        ),
        CustomPaint(
          painter: PentagonPainter(Colors.blue, currentIndex == 3),
          size: Size(width, height),
          child: Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 5, top: 5),
            child: Image.asset(
              assetList[3].iconPath,
              height: height,
              width: width,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          color: Colors.blue,
          width: 30,
          height: 1,
        ),
        CustomPaint(
          painter: PentagonPainter(Colors.blue, currentIndex == 4),
          size: Size(width, height),
          child: Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 5, top: 5),
            child: Image.asset(
              assetList[4].iconPath,
              height: height,
              width: width,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
