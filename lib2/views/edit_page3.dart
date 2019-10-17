// Define a custom Form widget.
//adapted from https://flutter.dev/docs/cookbook/forms/focus
import 'package:flutter/material.dart';
import '../models/background.dart';
import '../models/image_banner.dart';
import '../services/validation.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import '../models/drop_down_button.dart';
import '../models/ArtefactItem.dart';
import '../services/Uploader.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MyCustomForm extends StatefulWidget {
  final File artefactFile;
  final FirebaseUser user;
  final String familyId;

  const MyCustomForm({this.artefactFile, this.user, this.familyId});

  @override
  _MyCustomFormState createState() => _MyCustomFormState(artefactFile: this.artefactFile, user: user, familyId: familyId);

}

// Define a corresponding State class.
// This class holds data related to the form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Define the focus node. To manage the lifecycle, create the FocusNode in
  // the initState method, and clean it up in the dispose method.
  File artefactFile;
  final FirebaseUser user;
  final String familyId;
  String name;
  String description;
  List<String> tags = new List<String>();
  String year;


  _MyCustomFormState({this.artefactFile, this.user, this.familyId});

  //Each field has a different focus node, will focus on field when tapped
  FocusNode nameFocusNode;
  FocusNode descriptionFocusNode;
  FocusNode dateFocusNode;
  FocusNode tagFocusNode;
  FocusNode currentFocusNode;

  //controllers
  TextEditingController _editingController;
  TextEditingController _dateController;
  ScrollController scrollController;

  final GlobalKey<_MyCustomFormState> _mainKey = GlobalKey();
  static final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _fireStoreButtonVisibility = false;
  bool _submitVisibility = true;
  @override
  void initState() {
    super.initState();

    nameFocusNode = new FocusNode();
    descriptionFocusNode = new FocusNode();
    dateFocusNode = new FocusNode();
    tagFocusNode = new FocusNode();

    currentFocusNode = nameFocusNode;
    _editingController = new TextEditingController();
    scrollController = new ScrollController();

    year = "2019";
  }

  /// Cropper plugin
  Future<void> _cropImage() async {
    print("------------------------------------");
    print("CROPPING IMAGE");


    print("------------------------------------");

    ImageCropper imageCropper = new ImageCropper();
    File cropped = await ImageCropper.cropImage(
        sourcePath: artefactFile.path,
        // ratioX: 1.0,
        // ratioY: 1.0,
        // maxWidth: 512,
        // maxHeight: 512,
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.brown,
            toolbarWidgetColor: Colors.amberAccent,
            toolbarTitle: 'Crop It',
            statusBarColor: Colors.white,
            backgroundColor: Colors.brown,
            cropGridColor: Colors.amberAccent,
            activeControlsWidgetColor: Colors.amberAccent,
            activeWidgetColor: Colors.brown,
            cropFrameColor: Colors.amberAccent,
            dimmedLayerColor: Colors.black12

        )

        );


    setState(() {
      artefactFile = cropped ?? artefactFile;
    });
  }

  /// Remove image
  void _clear() {
    //setState(() => artefactFile = null);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    currentFocusNode.dispose();

    super.dispose();
  }


  //add a user-defined tag to the tagList
  void addTagToList(String tag) {
    tags.add(tag);

    print("=======================");
    for(int i=0; i < tags.length; i++) {
      print(tags[i]);

    }
    print("=======================");
  }

  void removeTagFromList(String tag) {
    int tagIndex;

    if(tags.contains(tag)) {

    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottomOpacity: 1.0,
          title: Text('ADD ARTEFACT', textAlign: TextAlign.center),
          centerTitle: true),
      body:
      //background is first in stack, then the column
      Stack(
          children: <Widget>[
            //background, then padding on top
            new Background(),
            //whole column wrapped in padding
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  controller: scrollController,
                  children: [
                    ImageBanner(artefactFile),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          color: Colors.white,
                          child: Icon(
                              Icons.crop,
                              color: Colors.brown),
                          onPressed: _cropImage,
                        ),
                        FlatButton(
                          color: Colors.white,
                          child: Icon(Icons.refresh, color: Colors.brown,),
                          onPressed: _clear,
                        ),
                      ],
                    ),
                    Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
                        child: Column(
                            children: [
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                validator: NameValidator.validate,
                                focusNode: nameFocusNode,
                                autofocus: true,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey,
                                  labelText: 'Enter the name of the artefact',
                                  hintText:'Name ',
                                ),
                                onSaved: (String value) {
                                  this.name = value;
                                },
                                onFieldSubmitted: (nameEntered) {
                                  this.name = nameEntered;
                                  print(this.name);

                                  _fieldFocusChange(context, nameFocusNode, descriptionFocusNode);
                                },
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                focusNode: descriptionFocusNode,
                                validator: DescriptionValidator.validate,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                  hintText: 'Enter a description about the artefact',
                                  labelText: 'Description ',
                                ),
                                onSaved: (String value) {
                                  this.description = value;
                                },
                                onFieldSubmitted: (descriptionEntered) {
                                  _fieldFocusChange(context, descriptionFocusNode, dateFocusNode);
                                },
                              ),
                              YearList(key: _mainKey,function: _setYear),
//                              // The first text field is focused on as soon as the app starts.
//                              TextFormField(
//                                controller: _dateController,
//                                textInputAction: TextInputAction.next,
//                                focusNode: dateFocusNode,
//                                keyboardAppearance: Brightness.dark,
//                                keyboardType: TextInputType.datetime,
//                                maxLines: 1,
//                                onTap: _pickDate,
//                                decoration: InputDecoration(
//                                  hintText: 'Enter the date the artefact originated',
//
//                                  labelText: 'Date (dd/mm/yyyy) ',
//                                ),
//                                validator: DateValidator.validate,
//
//                                onFieldSubmitted: (dateEntered) {
////                        stringToDate(dateEntered);
////                        //TODO: dateEntered to datetime type
////                        print(this.dateTime);
////
////                        //validate if date entered is correct
////                        bool validated = _formKey.currentState.validate() == null;
////                        print('date validated: ' + validated.toString());
////
////                        if(!validated) {
////                          print('validated');
//                                  _fieldFocusChange(context, dateFocusNode, tagFocusNode);
////                        }

//                                },
//                      onEditingComplete: () {
//                        _formKey.currentState.validate();
//                        currentFocusNode = tagFocusNode;
//                      },
//                              ),
//                              FlatButton(
//                                  onPressed: _pickDate,
//                                  child: Text(
//                                    'Date',
//                                    style: TextStyle(color: Colors.blue),
//                                  )
//                              ),
                              // The second text field is focused on when a user taps the
                              // FloatingActionButton.
                              TextFormField(
                                textInputAction: TextInputAction.done,
                                controller: _editingController,
                                focusNode: tagFocusNode,
                                decoration: InputDecoration(
                                  hintText: 'Enter tags related to the artefact',
                                  labelText: 'Tags: ',
                                ),
                                maxLines: 1,
                                onTap: (){
                                  _editingController.text = "";
                                },
                                onFieldSubmitted: (tag){
                                  addTagToList(tag);
                                  _editingController.text = "";
                                  _editingController.text = tags.toString();

                                  //TODO: displayTag(tag), deleting tags;
                                  //validate if description entered is correct
                                },
                              ),
                              Visibility(
                                visible: _fireStoreButtonVisibility,
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Uploader(
                                    user: user,
                                    familyId: familyId,
                                    file: widget.artefactFile,
                                    name:name,
                                    description: description,
                                    tags: tags,
                                    year: year,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _submitVisibility,
                                child: RaisedButton.icon(
                                  onPressed: _validateInputs,
                                  icon: Icon(Icons.add),
                                  label: Text('Submit'),
                                ),
                              )


                            ]
                          )
                        ),

                  ]
                )
            )
          ]
      ),

      floatingActionButton: FloatingActionButton(
        // When the button is pressed,
        // give focus to the text field using myFocusNode.
        onPressed: () {
          FocusScope.of(context).requestFocus(currentFocusNode);
        },
        tooltip: 'Focus Second Text Field',
        child: Icon(Icons.edit),
        backgroundColor: Colors.white70,
        hoverColor: Colors.black,

      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //goes to the next text field
  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
    currentFocusNode = nextFocus;
  }


  void
  _validateInputs() {
    final form = _formKey.currentState;
    if (form.validate()) {
      // Text forms was validated.
      form.save();

      print(this.name);
      print(this.description);
      print(this.year);
      print(this.tags.toString());

      setState(() {
        _fireStoreButtonVisibility = true;
        _submitVisibility = false;
      });

    } else {
      setState(() => _autoValidate = true);
    }
  }

  void
  _setYear(String newYear) {
    this.year = newYear;
  }

//  YearList
//  _pickYear() {
//    return new YearList();
//  }

//  void
//  _pickDate() async {
//    DateFormat dateFormat = new DateFormat('yyyy-MM-dd');
//    DateTime picked;
//
//
//    picked = await showDatePicker(
//        initialDatePickerMode: DatePickerMode.year,
//        context: context,
//
//        initialDate: DateTime.now(),
//        firstDate: DateTime(1500),
//        lastDate: DateTime.now(),
//        builder: (BuildContext context, Widget child) {
//          return Theme(
//              data: ThemeData.light(),
//              child: child
//          );
//        }
//    );
//
//    if (picked != null && picked != year){
//      setState(() {
//        dateTime = picked;
//      }
//      );
//    }
//    dateFormat.format(picked);
//
//    print(" picked: " + picked.toString());
//
//  }


}