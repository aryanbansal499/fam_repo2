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

import '../models/drop_down_button.dart';
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
class ImageCapture extends StatefulWidget {

  final FirebaseUser user;
  final String familyId;

  const ImageCapture({Key key, this.user, this.familyId}) : super(key: key);

  createState() => _ImageCaptureState(user: user, familyId: familyId);
}

class _ImageCaptureState extends State<ImageCapture> {
  /// Active image file
  File _imageFile;

  final FirebaseUser user;
  final String familyId;

  _ImageCaptureState({this.user, this.familyId});

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        // ratioX: 1.0,
        // ratioY: 1.0,
        // maxWidth: 512,
        // maxHeight: 512,
        androidUiSettings: AndroidUiSettings(

        toolbarColor: Colors.purple,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: 'Crop It'));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.photo_camera,
                size: 30,
              ),
              onPressed: () => _pickImage(ImageSource.camera),
              color: Colors.blue,
            ),
            IconButton(
              icon: Icon(
                Icons.photo_library,
                size: 30,
              ),
              onPressed: () => _pickImage(ImageSource.gallery),
              color: Colors.pink,
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
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
          ]
        ],
      ),
    );
  }
}

/// Widget used to handle the management of
class Uploader extends StatefulWidget {
  final File file;

  final FirebaseUser user;
  final String familyId;
  final String name;
  final String description;
  final List<String> tags;
  final String year;

  Uploader({Key key, this.file, this.user, this.familyId,this.description,this.name,this.tags,this.year}) : super(key: key);

  createState() => _UploaderState(user: user, familyId:familyId, description: description,
                                  name: name, tags: tags, year: year);
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
  final String name;
  final String description;
  final List<String> tags;
  final String year;

  _UploaderState({this.user, this.familyId,this.description,this.name,this.year,this.tags});

  _onSubmit() async {
    // call db.addArtefactFirestore which saves the artefact details onto Firestore
    // artefact = db.addArtefactFirestore() will return artefact snapshot,
    // get the artefact id for naming the artefact on storage
    // call _startUpload from Upload widget? or pass on artefact id to upload widget?
    // on Upload success get downloadUrl from artefact snapshot
    // add field to the artefact on firestore
    String url;

    String artefactId;

    var artefact = db.addArtefactFirestore(user, {
      'artefactLink': 'collection/doc', //
      'type': artefactType.IMG.toString(),
      'date': year,
      'description': description,
      'name': name,
      'tags': tags,
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
          onPressed: _onSubmit
          );
    }
  }
}

class StringValidator {
  static String validate(String value)
  {
    return value.isEmpty ? "Text field can't be empty " : null;
  }
}

class ArtefactEditAlertDialog extends StatelessWidget {
  TextEditingController _textFieldController = TextEditingController();

  //TODO refactor for editing the family name and description

  String _description;
  final _formKey = GlobalKey<FormState>();
  final _yearFormKey = GlobalKey<FormState>();
  String year;

  final db = DatabaseService();
  final artefact;
  final famId;

  ArtefactEditAlertDialog(this.artefact, this.famId);

  void
  _setYear(String newYear) {
    this.year = newYear;
  }

  bool validate() {
    final form = _formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {

      } catch (e) {
        print(e);
      }
    }
  }


  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Udate family description'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    validator: StringValidator.validate,

                    decoration: InputDecoration(
                        hintText: artefact.description),
                    onSaved: (value) => _description = value,
                  ),
                  YearList(key: _yearFormKey,function: _setYear),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('SUBMIT'),
                onPressed: () {
                  //TODO validate submission
                  submit();
                  //TODO call db
                  if (_description == null){
                    _description = artefact.description;
                  }
                  db.editArtefactDescription(famId, artefact.id, _description, year);

                  //TODO edit family, update data
                  //db.addFamily(user, {'name': _familyName, 'creator': user.uid, 'description': _description});
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Edit Family Description"),
      onTap: () => _displayDialog(context),
    );
  }
}
