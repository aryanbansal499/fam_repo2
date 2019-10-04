
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fam_repo2/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fam_repo2/widgets/image_banner.dart';
import 'package:fam_repo2/widgets/icon_button.dart';
import 'package:fam_repo2/background.dart';
import 'package:validators/validators.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';




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
  String _description;
  DateTime dateTime;
  String url;
  File sampleImage;
  final formKey = new GlobalKey<FormState>();
  var tagList = new List();

  String text = "Nothing to show";

  Future getImage() async
  {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
     sampleImage = tempImage; 
    });
  }
  bool validateAndSave()
  {
    final form = formKey.currentState;
    if (form.validate())
    {
      form.save();
      return true;
    }
  }

  void uploadStatusImage() async 
  {
    if(validateAndSave())
    {
      final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post Images");
      var timeKey = new DateTime.now();
      final StorageUploadTask storageUploadTask = postImageRef.child(timeKey.toString()+ ".jpg").putFile(sampleImage);

      var ImageUrl = await (await storageUploadTask.onComplete).ref.getDownloadURL();
      url = ImageUrl.toString();
      print("Image Url = " + url);
      
      goToHomePage();
      saveToDatabase(url);
    }
  }

  void saveToDatabase(url)
  {
    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('MMM d, yyyy');
    var formatTime = new DateFormat('EEEE,hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();
// use different modal classes here instead of just image 
    var data = 
    {
      "tags": tagList,
      "name": name,
      "image": url,
      "description": _description,
      "date": date,
      "time": time,
    };
    
    ref.child("Posts").push().set(data);
  }

  void dispose() {
    // Clean up the focus node when the Form is disposed.
    currentFocusNode.dispose();

    super.dispose();
  }
// used to go back to dashboard once the3 upload is successful
  void goToHomePage()
  {
    Navigator.push
    (
      context, 
      MaterialPageRoute
      (
        builder: (context)
        {
           return new HomePage();

        }
      )
    );
  }
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

  //add a user-defined tag to the tagList
  void addTagToList(String tag) {
    tagList.add(tag);

    print("=======================");
    for(int i=0; i < tagList.length; i++) {
      print(tagList[i]);

    }
    print("=======================");
  }

  @override
  Widget build(BuildContext context) {

     
    //TODO: MAKE ICONS INTO BUTTONS
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
        
        body: new Center
        (
          child: sampleImage == null ? toUpload(): setUpload(), 
        ),
    ); 
  }

  Widget toUpload()
  {
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
      onPressed: getImage,
      color: Colors.transparent
      )
    );

   return Stack(
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
      );
  }
  Widget setUpload()
  {
    body: 
    return Stack
    (
          children: <Widget>[
          new Background(),
          //whole column wrapped in padding
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              controller: scrollController,
              children: [
                Image.file(sampleImage,height: 265.0,width: 600.0,),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (value)
                        {
                          if( value.isEmpty)
                          {
                            return "Name is required";
                          }
                          else if (!isAlpha(value))
                          {
                            return "Name is not correct";
                          }
                          else return null;
                        },
                        focusNode: nameFocusNode,
                        autofocus: true,
                        decoration: InputDecoration(
                          fillColor: Colors.grey,
                          labelText: 'Enter the name of the artefact',
                          hintText:'Name ',
                        ),
                        onSaved: (value)
                        {
                          return name = value;
                        },
                      
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      focusNode: descriptionFocusNode,
                      validator: (value)
                      {
                        return value.isEmpty? 'Description is required' : null;
                      },
                      
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Enter a description about the artefact',
                        labelText: 'Description ',
                      ),
                      onSaved: (value)
                      {
                        return _description = value;
                      },
//                      
                    ),
                    
                     RaisedButton
                      (
                        elevation: 10.0,
                        child: Text("Add a New Post"),
                        textColor: Colors.white,
                        color: Colors.deepOrange,

                        onPressed: uploadStatusImage,
                      ),

                  ]
                )
              )
            ],
          )
        )
      ]
    );


  }
  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
    currentFocusNode = nextFocus;
  }
}