import 'package:flutter/material.dart';

final sizeConfig = SizeConfig();

class SizeConfig {
  static final SizeConfig _singleOpject = SizeConfig._internal();
  factory SizeConfig() {
    return _singleOpject;
  }
  SizeConfig._internal();
  double findHeight(double value) {
    //800 is android big phone screen height
    return (value * 100) / 800;
  }

  double findWidht(double value) {
    //360 is android big phone screen widht
    return (value * 100) / 360;
  }

  double heightSize(BuildContext context, double value) {
    value /= 100;
    print(MediaQuery.of(context).size.height);
    return MediaQuery.of(context).size.height * findHeight(value);
  }

  double widthSize(BuildContext context, double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * findWidht(value);
  }
}
