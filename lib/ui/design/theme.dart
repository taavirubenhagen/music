import 'package:flutter/material.dart';

abstract class Tavy {
  //static double scale(num t) => pow(2, t).toDouble();
  static buildHeightSpacer(double size) => SizedBox(
    height: size,
  );
  static double width(context) => MediaQuery.sizeOf(context).width;
  static double freeHeight(context) => MediaQuery.sizeOf(context).height;
  static double paddedHeight(context) => freeHeight(context) - MediaQuery.paddingOf(context).collapsedSize.height - 24; // TODO: R 24
}

abstract class Surfaces {
  static final Color floor = Color(0xFFFFFFFF);
  static final Color metal = Color(0xFF999999);
  static final Color blackMetal = Color(0xFF222222);
  static final Color black = Color(0xFF111111);
  static final Color darkWood = Colors.brown;
  static final Color lightWood = darkWood.withValues(alpha: 0.1);
}