import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fam_repo2/artefact_type.dart';


class MyButton extends StatelessWidget {
  final _snackbarString;
  final _button;
  final Color iconColor = Colors.brown;
  final double iconSize = 150.0;
  final ArtefactType _artefactType;

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
          case ArtefactType.AUDIO:
            break;
          case ArtefactType.TEXT:
            break;
          case ArtefactType.VIDEO:
            break;
          case ArtefactType.PICTURE:
            var picture = await ImagePicker.pickImage(
              source: ImageSource.camera,
            );
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

