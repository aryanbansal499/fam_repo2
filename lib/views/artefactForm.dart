//TODO this page is called when a floating button is pressed
// has the submit button which calls the database for post and returns an artefact id

// needs family ID as well to be passed onto it


import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../background.dart';
import '../icon_button.dart';
import '../services/middleware.dart';
import '../models/ArtefactItem.dart';


class ArtefactForm extends StatelessWidget{
  @override

  //TODO investigate if can use provider here

  final db = DatabaseService();

  final FirebaseUser user;
  final String familyId;

  ArtefactForm({Key key, this.user, this.familyId}) : super(key: key);

  String artefactId;
  

  //TODO add an onSubmit function
  _onSubmit() {
    // call db.addArtefactFirestore which saves the artefact details onto Firestore
    // artefact = db.addArtefactFirestore() will return artefact snapshot,
    // get the artefact id for naming the artefact on storage
    // call _startUpload from Upload widget? or pass on artefact id to upload widget?
    // on Upload success get downloadUrl from artefact snapshot
    // add field to the artefact on firestore
    String url;

    var artefact = db.addArtefactFirestore(user, {
      'artefactLink': 'collection/doc', //
      'type': artefactType.IMG.toString(),
      //'date': new DateTime.now(), //TODO change to year?
      'description': 'the beginning of many tests',
      'name': 'testing',
      'tags': ['#test'],
      'uploader': user.uid,
      'familyId': familyId,
    }
        , familyId);

    artefact.then((onValue) async {
      print(onValue.documentID);
      artefactId = onValue.documentID;
      //TODO idk about below comment for now
      //db.addArtefactStorage(familyId, onValue.documentID);
    });

    //TODO pass familyID and artefact id to Uploader widget to determine right path

    //TODO: onsuccess of upload, get download url of artefact and save to firestore
    // uncomment when upload widget is implemented
    //print((_uploadTask.onComplete.then((onValue) => onValue.ref.getDownloadURL())));
    /*_uploadTask.onComplete.then((onValue) => url = onValue.ref.getDownloadURL());
    artefact.then((onValue) => onValue.setData({'downloadUrl': url}));*/
  }


   
  Widget build(BuildContext context) {
    // TODO: implement build - form
    print(user.uid);
    print(familyId);
    // TODO: add Upload to firebase button
    return new Container();
  }

  

}

// Widget to capture and crop the image
class ArtefactUpload extends StatefulWidget {

  final FirebaseUser user;
  final String familyId;

  const ArtefactUpload({Key key, this.user, this.familyId}) : super(key: key);

  createState() => _ArtefactUploadState(user: user, familyId: familyId);
}

class _ArtefactUploadState extends State<ArtefactUpload> {
  /// Active image file
  File _imageFile;
  final FirebaseUser user;
  final String familyId;
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




_ArtefactUploadState({this.user, this.familyId});

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
  

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        // ratioX: 1.0,
        // ratioY: 1.0,
        // maxWidth: 512,
        // maxHeight: 512,
        toolbarColor: Colors.purple,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: 'Crop It');

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

//make changes here please add the upload_page2 here and work on the audio and text file system here.
  @override
  Widget build(BuildContext context) {

    var row1 = Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  //addText and  functionality in onPressed below.
                  new MyButton
                  (
                    "using text fields", IconButton(icon: Icon(Icons.text_fields, 
                    size: 150.0,color:  Colors.brown),
                    onPressed:(){},)
                  ),
                  new MyButton
                  (
                    "using audio", IconButton(icon:Icon(Icons.mic,
                    size: 150.0,color:  Colors.brown),
                    onPressed: (){},))
                ]
              );
    var row2 = Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                
                children: [
                  
                  new MyButton("using camera", IconButton(icon:Icon(Icons.camera_alt, 
                  size: 150.0,color:  Colors.brown),
                  onPressed: () => _pickImage(ImageSource.camera),),),
                  new MyButton("using gallery", IconButton(icon:Icon(Icons.photo, 
                  size: 150.0,color:  Colors.brown),
                  onPressed: () => _pickImage(ImageSource.gallery),),)               
                  ]
                );
    // var row3 = Container(
    //   margin: EdgeInsets.fromLTRB(0.0,16.0,16.0,0.0),
    //   child: Text('OR'), 
    //   );

    // var row4 = MyButton("redirecting to gallery", RaisedButton.icon(
    //   icon: Icon(Icons.file_upload), 
    //   label: Text("UPLOAD FROM GALLERY", textAlign: TextAlign.center,), 
    //   onPressed: () {},
    //   color: Colors.transparent
    //   )
    //);

  
    return Scaffold(
     // appbar
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottomOpacity: 1.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('ADD ARTEFACT', textAlign: TextAlign.center)]
              ),
            centerTitle: true
            ),

      
        body: _imageFile != null ?   
        Container
        ( 
          decoration: BoxDecoration
          (
            image: DecorationImage
            (
              image: AssetImage('images/bg.png'),
              fit: BoxFit.cover
            )
          ),
          child: ListView(
          children: <Widget>[
        
            Container(
                 
                padding: EdgeInsets.all(32), child: Image.file(_imageFile)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  color: Colors.black,
                  child: Icon(Icons.crop),
                  onPressed: _cropImage,
                ),
                FlatButton(
                  color: Colors.black,
                  child: Icon(Icons.refresh),
                  onPressed: _clear,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Uploader(
                file: _imageFile,
                user: user,
                familyId: familyId,
              ),
            )
          ],
      ) 
    )
       
      
      :
      
       Stack(
        children: <Widget>[
          new Background(),
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent
            ),
            margin: EdgeInsets.all(15.0),
            padding: EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,          
              children: [
                row1,
                row2,
                //row3,
                //row4
              ]
              )
          )  
        ]
      )
     
    );

  

  }

}

/// Widget used to handle the management of
class Uploader extends StatefulWidget {
  final File file;

  final FirebaseUser user;
  final String familyId;

  Uploader({Key key, this.file, this.user, this.familyId}) : super(key: key);

  createState() => _UploaderState(user: user, familyId:familyId);
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
  FirebaseStorage(storageBucket: 'gs://baseproject-72dc9.appspot.com');

  StorageUploadTask _uploadTask;

  final db = DatabaseService();

  //String familyId = 'KBd6yfSbTIPPK3jesORH';
  //String artefactId = '';

  final FirebaseUser user;
  final String familyId;

  _UploaderState({this.user, this.familyId});

  _onSubmit() async {
    // call db.addArtefactFirestore which saves the artefact details onto Firestore
    // artefact = db.addArtefactFirestore() will return artefact snapshot,
    // get the artefact id for naming the artefact on storage
    // call _startUpload from Upload widget? or pass on artefact id to upload widget?
    // on Upload success get downloadUrl from artefact snapshot
    // add field to the artefact on firestore.
    String url;

    String artefactId;

    var artefact = db.addArtefactFirestore(user, {
      'artefactLink': 'collection/doc', //
      'type': artefactType.IMG.toString(),
      //'date': new DateTime.now(), //TODO change to year?
      'description': 'the beginning of many tests',
      'name': 'testing',
      'tags': ['#test'],
      'uploader': user.uid,
      'familyId': familyId,
    }
        , familyId);


    artefact.then((onValue) async {
      print('doc id ' + onValue.documentID);
      artefactId = onValue.documentID;
      //TODO idk about below comment for now
      //db.addArtefactStorage(familyId, onValue.documentID);
      //TODO pass familyID and artefact id to Uploader widget to determine right path
      setState(() {
        _uploadTask = _storage.ref().child('families/$familyId/$artefactId').putFile(widget.file);
      });

      _uploadTask.onComplete.then((onValue) {
        onValue.ref.getDownloadURL().then((dwlurl) {
          url = dwlurl;
          print(url);
          artefact.then((onValue) => onValue.updateData({'downloadUrl': url}));
              //.setData({'downloadUrl': url}));
        });
      });

    });


    //TODO: onsuccess of upload, get download url of artefact and save to firestore
    // uncomment when upload widget is implemented
    //print((_uploadTask.onComplete.then((onValue) => onValue.ref.getDownloadURL())));
    /*_uploadTask.onComplete.then((onValue) {
      onValue.ref.getDownloadURL().then((dwlurl) {
        url = dwlurl;
        print(url);
        artefact.then((onValue) => onValue.setData({'downloadUrl': url}));
      });
    });*/
  }

  Future<StorageUploadTask> _startUpload() async {
    String filePath = 'images/${DateTime.now()}.png';
    String url;

    setState(() {
      _uploadTask = _storage.ref().child('families/${familyId}/test').putFile(widget.file);
    });

    // call db.addArtefact and get artefact id


    //print((_uploadTask.onComplete.then((onValue) => onValue.ref.getDownloadURL())));

    return _uploadTask;


    // add download url to the artefact uploaded ... set Data using familyid and artefact id
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_uploadTask.isComplete)
                    Text('🎉🎉🎉',
                        style: TextStyle(
                            color: Colors.greenAccent,
                            height: 2,
                            fontSize: 30)),
                  if (_uploadTask.isPaused)
                    FlatButton(
                      child: Icon(Icons.play_arrow, size: 50),
                      onPressed: _uploadTask.resume,
                    ),
                  if (_uploadTask.isInProgress)
                    FlatButton(
                      child: Icon(Icons.pause, size: 50),
                      onPressed: _uploadTask.pause,
                    ),


                  LinearProgressIndicator(value: progressPercent),
                  Text(
                    '${(progressPercent * 100).toStringAsFixed(2)} % ',
                    style: TextStyle(fontSize: 50),
                  ),
                ]);
          });
    } else {
      return FlatButton.icon(
          color: Colors.blue,
          label: Text('Upload to Firebase'),
          icon: Icon(Icons.cloud_upload),
          onPressed: _onSubmit);
    }
  }
}
