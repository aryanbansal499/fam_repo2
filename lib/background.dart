/**
 * To use this class, you must wrap it in a stack widget in body:,
 *  first stack: background, second is the column widget etc.
 */
import 'package:flutter/material.dart';

class Background extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return new Center(
      child: new Image.asset(
              'images/bg.png',
              width: screenSize.width,
              height: screenSize.height,
              fit: BoxFit.fitHeight)
      );
  }
}