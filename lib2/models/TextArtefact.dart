import 'dart:io';

import 'package:fam_repo2/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../views/auth.dart';
import '../views/edit_page3.dart';
import 'background.dart';

class TextArtefactForm extends StatefulWidget{

  final FirebaseUser user;
  final String familyId;

  const TextArtefactForm({this.user, this.familyId});
  _TextArtefactForm createState() => _TextArtefactForm(user: user, familyId: familyId);

  
  }

 
  class _TextArtefactForm extends State<TextArtefactForm> with SingleTickerProviderStateMixin{

  TabController _controller;
  TextEditingController _textEditingController;
  String text = "";
  String title ="";
  File artefactFile;
  final FirebaseUser user;
  final String familyId;
  static final _formKey = GlobalKey<FormState>();

  _TextArtefactForm({this.user, this.familyId});
   @override
   void initState()
  {
    _controller = TabController(length: 2,vsync: this);
    _textEditingController = TextEditingController();
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
                                onFieldSubmitted: (nameEntered) {
                                  this.title = nameEntered;
                                  print(this.title);

                                  //_fieldFocusChange(context, nameFocusNode, descriptionFocusNode);
                                },
                              ),
                              TextFormField(
                                controller: _textEditingController,
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
                                },
                                // onFieldSubmitted: (descriptionEntered) {
                                //   //_fieldFocusChange(context, descriptionFocusNode, dateFocusNode);
                                // },
                              ),
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
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children:
            [
              
              FloatingActionButton
              (
                backgroundColor: Colors.brown,
                child: Icon(Icons.arrow_forward, color: Colors.white30),
                onPressed: (){saveArtefact(text,title);},
              ),
            ]
         ),
          
        ],
      ),


      ),
    );
  }

  Future saveArtefact (String text, String title) async
  {
    var textFile = File(title+'.txt').writeAsStringSync(text);
    Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyCustomForm(user: user, familyId: familyId, artefactFile: (textFile) as File )));
  }

}