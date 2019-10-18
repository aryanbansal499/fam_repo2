import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../services/middleware.dart';
import '../services/Uploader.dart';
import '../views/auth.dart';
import '../views/edit_page3.dart';
import 'background.dart';
import 'ArtefactItem.dart';

class TextArtefactForm extends StatefulWidget{

  final FirebaseUser user;
  final String familyId;

  const TextArtefactForm({this.user, this.familyId});
  _TextArtefactForm createState() => _TextArtefactForm(user: user, familyId: familyId);

  
  }

 
  class _TextArtefactForm extends State<TextArtefactForm> with SingleTickerProviderStateMixin{

  final FirebaseStorage _storage =
  FirebaseStorage(storageBucket: 'gs://baseproject-72dc9.appspot.com');

  StorageUploadTask _uploadTask;
  TabController _controller;
  TextEditingController _textEditingController;
  TextEditingController _textEditingController2;
  String text = "";
  String title ="";
  File artefactFile;
  final DatabaseService db = DatabaseService();
  final FirebaseUser user;
  final String familyId;
  bool _fireStoreButtonVisibility = false;
  bool _submitVisibility = true;
  bool _autoValidate = false;
  static final _formKey = GlobalKey<FormState>();

  _TextArtefactForm({this.user, this.familyId});
   @override
   void initState()
  {
    _controller = TabController(length: 2,vsync: this);
    _textEditingController = TextEditingController();
    _textEditingController2 = TextEditingController();
    super.initState();
    
  }
  final TextStyle style = TextStyle(color: Colors.black);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold
    (
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text("Write Down Your Memories",
               style: TextStyle(color: Colors.black),),
      ),
      body:

      
      Container(
       
      decoration: BoxDecoration(
            image: DecorationImage(
            image: AssetImage("images/bg.png"),
            fit: BoxFit.cover,)),

      child: ListView(
        
        
        children:
        [

          Form(
                        key: _formKey,
                        autovalidate: true,
                        child: Column(
                            children: [
                              TextFormField(
                                textCapitalization: TextCapitalization.words,
                                controller: _textEditingController,
                                textAlign: TextAlign.center,
                                textInputAction: TextInputAction.next,
                                maxLength: 30,
                                //validator: NameValidator.validate,
                                style: TextStyle(fontSize: 25,
                                       fontWeight: FontWeight.bold,
                                       color: Colors.black),
                                autofocus: true,
                                decoration: InputDecoration(
                                  fillColor: Colors.brown,
                                  //labelText: 'Enter the Title of the artefact',
                                  hintText: 'Title',
                                ),
                                onSaved: (String value) {
                                  this.title = value;
                                },
                                
                              ),
                              TextFormField(
                                controller: _textEditingController2,
                                textInputAction: TextInputAction.next,
                                //focusNode: descriptionFocusNode,
                                //validator: DescriptionValidator.validate,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                hintText: 'Type here',
                
                                ),
                                onSaved: (String value) {
                                  this.text = value;
                                  createFile(this.title, this.text,artefactFile);
                                },
                                // onFieldSubmitted: (descriptionEntered) {
                                //   //_fieldFocusChange(context, descriptionFocusNode, dateFocusNode);
                                // },
                              ),

                              Visibility(
                                visible: _fireStoreButtonVisibility,
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Uploader(
                                    user: user,
                                    familyId: familyId,
                                    file:artefactFile,
                                    name:title,
                                    description: text,
                                    tags: null,
                                    year: "null",
                                  ),

                                ),
                              ),
                              Visibility(
                                visible: _submitVisibility,
                                child: RaisedButton.icon(
                                  onPressed: _validateInputs, //(){_formKey.currentState.save();
                                  // _fireStoreButtonVisibility = true;
                                  // _submitVisibility = false;},
                                  icon: Icon(Icons.add),
                                  label: Text('Submit'),
                                ),
                              )
                            ],
                            ),
          ),
                            
          
          // Container
          // (
          //   margin: EdgeInsets.all(20),
          //   child:
          //   TextField
          //   (
          //     keyboardType: TextInputType.multiline,
          //     maxLines: null,
          //     controller: _textEditingController,
          //     decoration: InputDecoration
          //     (
          //       border: InputBorder.none,
          //       hintText: "Type here"
          //     ),
          //     onChanged: (String text)
          //     {
          //       Markdown(data: text);
          //       setState(() {
          //         this.text = text;
          //       });
          //     },
              
          //   )
          // ),
          Divider
          (
            height: 10.0
            ,
          ),
          Column
          (
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children:
            [
              
            ]
         ),
          
        ],
      ),


      ),
    );
  }

  // void saveArtefact (String text, String title) //async
  // {
  //   //var file = await File('dorm.txt').writeAsString(text);
  //   Navigator.push(context,
  //               MaterialPageRoute(builder: (context) => 
  //   Uploader(
  //                                   user: user,
  //                                   familyId: familyId,
  //                                   file:null,//file,//File('textFile as File'),
  //                                   name:title,
  //                                   description: text,
  //                                   tags: ["null"],
  //                                   year: "null",)
  //                                   ,)
  //                                   );
  // }

  void createFile(String title,String text, File artefactFile)
  {

      print(text);
      print(title);
      final filename = title+'.txt';
      new File(filename).writeAsString(text)
      .then((File file) {
      // Do something with the file.
      artefactFile = file;
    });
  } 

   void
  _validateInputs() {
    final form = _formKey.currentState;
    if (form.validate()) {
      // Text forms was validated.
      form.save();

      setState(() {
        _fireStoreButtonVisibility = true;
        _submitVisibility = false;
      });

    } else {
      setState(() => _autoValidate = true);
    }
  }

}

   
