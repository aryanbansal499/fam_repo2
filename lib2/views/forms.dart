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
import 'package:thebugs_prototype/services/middleware.dart';
import 'package:thebugs_prototype/models/ArtefactItem.dart';

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

  Uploader({Key key, this.file, this.user, this.familyId}) : super(key: key);

  createState() => _UploaderState(user: user, familyId:familyId);
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
  FirebaseStorage(storageBucket: 'gs://thebug-test.appspot.com/');

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
    // add field to the artefact on firestore
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
