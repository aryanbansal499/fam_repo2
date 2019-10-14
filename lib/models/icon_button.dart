import '../views/edit_page3.dart';
import '../models/ArtefactItem.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class MyButton extends StatelessWidget {
  final _snackbarString;
  final _button;
  static final Color iconColor = Colors.brown;
  static final double iconSize = 150.0;
  final artefactType _artefactType;

  MyButton(this._snackbarString, this._button, this._artefactType);

  @override
  Widget build(BuildContext context) {
    // The GestureDetector wraps the button.
    return GestureDetector(
      // When the child is tapped, show a snackbar.
      onTap: () async {
        final snackBar = SnackBar(content: Text(_snackbarString));

        Scaffold.of(context).showSnackBar(snackBar);

        switch (_artefactType) { 
          case artefactType.AUD:
            break;
          case artefactType.TXT:
            break;
          case artefactType.VID:
            break;
          case artefactType.IMG:
            File picture = await ImagePicker.pickImage(
              source: ImageSource.camera,
            );
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyCustomForm(artefactFile: picture)));
            //TODO:GO TO EDIT PAGE WITH picture object
            break;
        }
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

