import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/background.dart';
import '../models/icon_button.dart';
import '../models/ArtefactItem.dart';
import 'package:image_picker/image_picker.dart';

import '../style.dart';

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
                  color: MaroonAccentColourT
              ),
              artefactType.TXT,
            user,
            familyId
          ),

          new MyButton("using audio",
              Icon(
                  Icons.mic,
                  size: iconSize,
                  color: MaroonAccentColourT
              ),
              artefactType.AUD,
            user,
            familyId
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
                  color: MaroonAccentColourT
              ),
              artefactType.IMG,
              user,
              familyId
          ),
          new MyButton(
              "accessing video camera",
              Icon(
                  Icons.videocam,
                  size: iconSize,
                  color: MaroonAccentColourT
              ),
              artefactType.VID,
            user,
            familyId
          )
        ]
    );
    var row3 = Container(
      margin: EdgeInsets.fromLTRB(0.0,16.0,16.0,0.0),
      child: Text('OR',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontFamily: FontNameSubtitle,
            fontSize: 25,
            color: IconOnAppBarColour
          )),
    );

    var row4 = MyButton(
        "redirecting to gallery",
        RaisedButton.icon(
          icon: Icon(Icons.insert_photo,),
          label: Text("Upload from gallery",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w900,
              fontFamily: FontNameSubtitle,
              )),
        ),
        artefactType.GAL,
        user,
        familyId
    );

    var row5 = MyButton(
        "redirecting to gallery",
        Text('Upload from gallery',
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: FontNameSubtitle,
        fontSize: 23,
        fontWeight: FontWeight.w900,
        decoration: TextDecoration.underline,
        color: GoldAccentColourDark,),),
        artefactType.GAL,
        user,
        familyId
    );


    return Stack(
      children: <Widget>[
        new Container(
          height: double.infinity,
          width: double.infinity,
          decoration:new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("images/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(
                  color: IconOnCardColour, //change your color here
                ),
                elevation: 0,
                title: Text('ADD ARTEFACT', textAlign: TextAlign.center),
                centerTitle: true),

            body: Stack(
                children: <Widget>[
                  //new Background(),
                  Container(
                      margin: EdgeInsets.all(5.0),
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            row1,
                            row2,
                            row3,
                            row5
                          ]
                      )
                  )
                ]
            )
        ),
      ],
    );
  }
}