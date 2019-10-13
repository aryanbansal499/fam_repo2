import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final _snackbarString;
  final  _button;
  final Color iconColor = Colors.brown;
  final double iconSize = 150.0;

  MyButton(this._snackbarString, this._button);

  @override
  Widget build(BuildContext context) {
    // The GestureDetector wraps the button.
    return GestureDetector(
      // When the child is tapped, show a snackbar.
      onTap: () {
        final snackBar = SnackBar(content: Text(_snackbarString));

        Scaffold.of(context).showSnackBar(snackBar);
      },
      // The custom button
      child: Container(
        padding: EdgeInsets.all(12.0),
        margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: _button
        
      ),
    );
  }
}

