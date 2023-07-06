import 'package:flutter/material.dart';
import 'package:water_alarm/ui/widgets/vertical_space.dart';

class GenderAvatar extends StatelessWidget {
  const GenderAvatar(
      {super.key,
      required this.assetsImage,
      required this.genderName,
      required this.isSelected});
  final String assetsImage;
  final String genderName;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
              image: DecorationImage(image: AssetImage(assetsImage))),
        ),
        const VerticalSpace(height: 6),
        Text(genderName,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue : Colors.grey))
      ],
    );
  }
}
