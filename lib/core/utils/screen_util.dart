import 'package:flutter/widgets.dart';

class ScreenUtil {
  static const double designedHeight = 824;
  static const double designedWidth = 412;

  static double screenWidth(BuildContext context) => MediaQuery.sizeOf(context).width;

  static double screenHeight(BuildContext context) => MediaQuery.sizeOf(context).height;

  static double textSizeAdaptive(BuildContext context, double textSize) {
    //double h = screenHeight(context);
    double w = screenWidth(context);
    
    return textSize * (w / designedWidth);
  }
}