import 'package:flutter/material.dart';

const LargeTextSize = 26.0;
const MediumTextSize = 20.0;
const BodyTextSize = 16.0;
const AppBarTextSize = 26.0;

const String FontNameDefault = 'Adobe Song Std';
const String FontNameAppBarTitle = 'Letter Gothic Std';
const String FontNameSubtitle = 'Ming Liu';

const Color IconOnCardColour = Color.fromRGBO(78, 48, 44, 1);
const Color IconOnAppBarColour = Color.fromRGBO(78, 48, 44, 1);

const AppBarTextStyle = TextStyle(
  fontFamily: FontNameAppBarTitle,
  fontWeight: FontWeight.w600,
  fontSize: AppBarTextSize,
  color: Color.fromRGBO(78, 48, 44, 1),
);

const SubtitleTextStyle = TextStyle(
  fontFamily: FontNameSubtitle,
  fontWeight: FontWeight.w300,
  fontSize: MediumTextSize,
  color: Colors.brown,
);

const TitleTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w200,
  fontSize: LargeTextSize,
  color: Colors.brown,
);

const Body1TextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w300,
  fontSize: BodyTextSize,
  color: Color.fromRGBO(78, 48, 44, 1),
);