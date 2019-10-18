import '../views/edit_page3.dart';
import '../models/ArtefactItem.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'TextArtefact.dart';



class MyButton extends StatelessWidget {
  final _snackbarString;
  final _button;
  static final Color iconColor = Colors.brown;
  static final double iconSize = 150.0;
  final artefactType _artefactType;
  final user;
  final family;

  MyButton(this._snackbarString, this._button, this._artefactType, this.user, this.family);

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
            Navigator.push(context,
                            MaterialPageRoute(builder: (context) => TextArtefactForm(user: user, familyId: family)));
            break;
          case artefactType.VID:
            File video  = await ImagePicker.pickVideo(
              source: ImageSource.camera,
            );
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyCustomForm(user: user, familyId: family, artefactFile: video)));
            break;
          case artefactType.IMG:
            File picture = await ImagePicker.pickImage(
              source: ImageSource.camera,
            );
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyCustomForm(user: user,familyId:family,artefactFile: picture)));
            //TODO:GO TO EDIT PAGE WITH picture object
            break;
          case artefactType.GAL:
            File picture = await ImagePicker.pickImage(
              source: ImageSource.gallery,
            );
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyCustomForm(user:user,familyId:family,artefactFile: picture)));
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



