import 'package:flutter/material.dart';

const double iconSize = 25;

const double cBorderRadius = 10;
const double bBorderRadius = 5;

double sWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double sHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

TextStyle verySmallText = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
);

TextStyle smallText = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
);

TextStyle smallBoldText = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
);

TextStyle smallBolderText = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
);

TextStyle mediumText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
);

TextStyle mediumBoldText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

TextStyle mediumBolderText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

TextStyle semiLargeText = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
);

TextStyle semiLargeBoldText = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
);

TextStyle largeText = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
);

TextStyle largeBoldText = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
);
