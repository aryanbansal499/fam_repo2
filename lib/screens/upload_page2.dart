import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/components/background.dart';
import 'package:my_app/components/icon_button.dart';
import 'package:my_app/components/image_banner/image_banner.dart';
import 'package:my_app/screens/upload_page/text_section.dart';

class UploadPage2 extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

//This class provides the opti
class _UploadPageState extends State<UploadPage2> {
  // Define the focus node. To manage the lifecycle, create the FocusNode in
  // the initState method, and clean it up in the dispose method.
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
                  new MyButton("using text fields", Icon(Icons.text_fields, size: iconSize,color: iconColor)),
                  new MyButton("using audio", Icon(Icons.mic, size: iconSize,color: iconColor))
                ]
              );
    var row2 = Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                
                children: [
                  new MyButton("using camera", Icon(Icons.camera_alt, size: iconSize,color: iconColor)),
                  new MyButton("using video", Icon(Icons.videocam, size: iconSize,color: iconColor))               
                ]
                );
    var row3 = Container(
      margin: EdgeInsets.fromLTRB(0.0,16.0,16.0,0.0),
      child: Text('OR'), 
      );

    var row4 = MyButton("redirecting to gallery", RaisedButton.icon(
      icon: Icon(Icons.file_upload), 
      label: Text("UPLOAD FROM GALLERY", textAlign: TextAlign.center,), 
      onPressed: () {},
      color: Colors.transparent
      )
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
                  color: Colors.brown,
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