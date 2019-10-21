import 'dart:io';
import '../views/artefacts.dart';
import '../views/edit_page3.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/ArtefactItem.dart';
import '../services/middleware.dart';
import '../services/validation.dart';
import '../views/home.dart';

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

  bool __uploaderVisibility = true;
  bool _goBackVisibility = false;


  _onSubmit() async {
    // call db.addArtefactFirestore which saves the artefact details onto Firestore
    // artefact = db.addArtefactFirestore() will return artefact snapshot,
    // get the artefact id for naming the artefact on storage
    // call _startUpload from Upload widget? or pass on artefact id to upload widget?
    // on Upload success get downloadUrl from artefact snapshot
    // add field to the artefact on firestore
    String url;

    String artefactId;
    String filePath = 'images/${DateTime.now()}.png';


    var artefact = db.addArtefactFirestore(user, {
      'artefactLink': 'collection/doc', //
      'type': artefactType.IMG.toString(),
      'date': year, //TODO change to year?
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

        __uploaderVisibility = false;
        _goBackVisibility = true;

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
            children:[
              Visibility(
              visible: __uploaderVisibility,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_uploadTask.isComplete)
                    Text('🎉🎉🎉',
                        style: TextStyle(
                            color: Colors.greenAccent,
                            height: 2,
                            fontSize: 30),
                        ),
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
                ])
            ),
            Visibility(
              visible: _goBackVisibility,
              child: RaisedButton.icon(
                label: Text('Artefacts'),
                icon: Icon(Icons.arrow_forward, size: 50),
                onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Buffer(id: familyId)));
                },
              ),
            )]);
          });
    } else {
      return FlatButton.icon(
          color: Colors.white,
          label: Text('Upload'),
          icon: Icon(Icons.navigate_next),
          onPressed: _onSubmit);
    }
  }
}