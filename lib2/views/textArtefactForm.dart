import 'dart:ffi';
import 'dart:io';

import 'file:///C:/Flutter%20Project/fam_repo2_latest5/lib2/services/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/background.dart';
import '../models/icon_button.dart';
import '../models/ArtefactItem.dart';
import 'package:image_picker/image_picker.dart';

class TextArtefactForm extends StatefulWidget {

  @override
  _TextArtefactFormState createState() => _TextArtefactFormState();

}

//This class provides the opti
class _TextArtefactFormState extends State<TextArtefactForm> {
  // Define the focus node. To manage the lifecycle, create the FocusNode in
  // the initState method, and clean it up in the dispose method.

  //File textFile = new File();
  String textString = "";

  bool _autovalidate = false;

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //TODO: MAKE ICONS INTO BUTTONS


    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            bottomOpacity: 1.0,
            title: Text('ADD A TEXT ARTEFACT', textAlign: TextAlign.center),
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
                        Form(
                          autovalidate: _autovalidate,
                          child: Column(

                              children: [TextFormField(
                            maxLines: null,
                            onSaved: (text) {
                              textString = text;

                              //TODO: CONVERT STRING TO TEXT FILE?
                            },
                            validator: TextArtifactValidator.validate,


                          ),
                          RaisedButton(
                            child: Text('Submit'),
                            onPressed: _validateForm,

                          )
                        ]
                      )
                    )
                  ]
                )
              )

    );
  }

  void
  _validateForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      // Text forms was validated.
      form.save();


    } else {
      setState(() => _autovalidate = true);
    }
  }

}