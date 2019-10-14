import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/background.dart';
import '../models/icon_button.dart';
import '../models/ArtefactItem.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage2 extends StatefulWidget {
  final FirebaseUser user;
  final String familyId;

  const UploadPage2({Key key, this.user, this.familyId}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState(user: user, familyId: familyId);

}

//This class provides the opti
class _UploadPageState extends State<UploadPage2> {
  // Define the focus node. To manage the lifecycle, create the FocusNode in
  // the initState method, and clean it up in the dispose method.
  final FirebaseUser user;
  final String familyId;

  _UploadPageState({this.user, this.familyId});

  FocusNode nameFocusNode;
  FocusNode descriptionFocusNode;
  FocusNode dateFocusNode;
  FocusNode tagFocusNode;

  FocusNode currentFocusNode;
  TextEditingController _editingController;
  ScrollController scrollController;

  final double iconSize = 150.0;
  final Color iconColor = Colors.brown;

  String name;
  String description;
  DateTime dateTime;
  var tagList = new List();

  var artefact;

  String text = "Nothing to show";

  @override
  void initState() {
    super.initState();

    nameFocusNode = new FocusNode();
    descriptionFocusNode = new FocusNode();
    dateFocusNode = new FocusNode();

    currentFocusNode = nameFocusNode;
    _editingController = new TextEditingController();
    scrollController = new ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: MAKE ICONS INTO BUTTONS


    var row1 = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          new MyButton("using text fields",
              Icon(
                  Icons.text_fields,
                  size: iconSize,
                  color: iconColor
              ),
              artefactType.TXT
          ),

          new MyButton("using audio",
              Icon(
                  Icons.mic,
                  size: iconSize,
                  color: iconColor
              ),
              artefactType.AUD
          )
        ]
    );
    var row2 = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,

        children: [
          new MyButton(
              "accessing camera",
              Icon(
                  Icons.camera_alt,
                  size: iconSize,
                  color: iconColor
              ),
              artefactType.IMG
          ),
          new MyButton(
              "accessing video camera",
              Icon(
                  Icons.videocam,
                  size: iconSize,
                  color: iconColor
              ),
              artefactType.VID
          )
        ]
    );
    var row3 = Container(
      margin: EdgeInsets.fromLTRB(0.0,16.0,16.0,0.0),
      child: Text('OR'),
    );

    var row4 = MyButton(
        "redirecting to gallery",
        RaisedButton.icon(
          icon: Icon(Icons.insert_photo),
          label: Text("UPLOAD FROM GALLERY", textAlign: TextAlign.center,),
          onPressed: () async {
            artefact = await ImagePicker.pickImage(
              source: ImageSource.gallery,
            );
            //TODO: send to edit page
          },
        ),
        artefactType.IMG
    );

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            bottomOpacity: 1.0,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 30.0,
                        semanticLabel: 'icon to go back to previous page'
                    ),
                    onPressed:(){
                      print('GOING BACK');
                    }
                    ,

                  ),
                  Text('ADD ARTEFACT', textAlign: TextAlign.center)]
            ),
            centerTitle: true),

        body: Stack(
            children: <Widget>[
              new Background(),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent
                  ),
                  margin: EdgeInsets.all(5.0),
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        row1,
                        row2,
                        row3,
                        row4
                      ]
                  )
              )
            ]
        )
    );
  }
}