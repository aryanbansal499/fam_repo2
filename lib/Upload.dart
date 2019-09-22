import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';




class UploadPage extends StatefulWidget
{
  

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UploadPageState();
  }
}

class _UploadPageState extends State<UploadPage>{

  File sampleImage;
  String _myValue;

  final formKey = new GlobalKey<FormState>(); 

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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar
      (
        title: new Text("Upload Page"),
        centerTitle: true,
      ),

      body: new Center 
      (
        child: sampleImage == null ? Text("Select an Image"): enableUpload(),
        ),
     
     floatingActionButton: new FloatingActionButton
     (
       onPressed: getImage,
       tooltip: 'Add Image',
       child : new Icon(Icons.add_a_photo), 
     ),
    );
  }
  


  Widget enableUpload()
  {
    return Container
    (
      child: new Form
      (
        key: formKey,
      child: Column
      (
        children: <Widget>
        [
          Image.file(sampleImage,height: 265.0,width: 600.0,),
          
          SizedBox(height: 15.0,),
          RaisedButton
          (
            elevation: 10.0,
            child: Text("Add a New Post"),
            textColor: Colors.white,
            color: Colors.deepOrange,

            onPressed: validateAndSave,
          ),
          TextFormField
          (
            decoration: new InputDecoration(labelText: 'Description'),
            validator: (value)
            {
              return value.isEmpty? 'Blod Description is required' : null;


            },
            onSaved: (value)
            {
               return _myValue = value;
            },
          )
      
        ],
      ),
      ),

    );
  }
}