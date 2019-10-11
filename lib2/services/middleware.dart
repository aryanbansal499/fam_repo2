import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:thebugs_prototype/models/ArtefactItem.dart';
import 'package:thebugs_prototype/models/Family.dart';
import 'package:thebugs_prototype/models/Profile.dart';


class DatabaseService {
  final Firestore _db = Firestore.instance;
  final FirebaseStorage _storage =
  FirebaseStorage(storageBucket: 'gs://thebug-test.appspot.com/');

  Future<User> getProfile(String id) async {
    var snap = await _db.collection('users').document(id).get();

    return User.fromMap(snap.data);
  }

  /// Get a stream of a single document
  Stream<User> streamUser(String id) {
    return _db
        .collection('users')
        .document(id)
        .snapshots()
        .map((snap) => User.fromMap(snap.data));
  }

  /// Query a subcollection
  Stream<List<ArtefactItem>> streamArtefacts(FirebaseUser user, String famId) {
    //TODO make the family input dynamic
    var ref = _db.collection('families').document(famId).collection('artefacts'); //.where('familyId', isEqualTo: famId);
    // TO-DO;

    //TODO show images instead of text list
    if (ref.snapshots() == null) {
      return null;
    }

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => ArtefactItem.fromFirestore(doc)).toList());

  }

  Future<void> createUser(FirebaseUser user) {
    return _db
        .collection('users')
        .document(user.uid)
        .setData({
      'name': 'Tester need to save from form ${user.uid.substring(0,5)}'
      , 'description': 'get from profile'
      , 'email': 'get from form'
      , 'families': ['test1']
      , 'private': true
      , 'username': 'tester'});
  }

  Future<void> signOut(auth) async {
    return auth.signOut();
  }


  Future<void> addFamily(FirebaseUser user, dynamic family) {
    //get family uid and link to collection into families array
    //_db.collection('users').document(user.uid).setData(data)
    //List<String> fams =  _getFamilies(user);
    //fams.add('test');

    // should also call firebase storage and add a new folder dynamically
    return _db
        .collection('families')
        .add(family); // uncomment when not prototyping
  }

  // Call addArtefact upon submission of upload artefact page
  Future<DocumentReference> addArtefactFirestore(FirebaseUser user, dynamic artefact, dynamic family) {
    //TODO implement file upload when adding artefact
    //add artefact to storage with the artefact id as the storage file name
    // after, query the storage with the artefact id in filepath to get the download url
    // add the download url into the artefact properties
    // place the download url as the Image.network widget

    //storage upload
    //_storage.ref().child(family).putFile(artefact.id);
    // ^ dilemma artefact id only exists after adding to database?

    return _db
        .collection('families')
        .document(family)
        .collection('artefacts')
        .add(artefact);
  }


  //TODO remove if proven unecessary
  Future<void> addArtefactStorage(familyId, artefactId, url){
    // add to firebase storage
    // add a field to firestore artefact object
    //File file = new File('services/tester.txt');
    //print(file.readAsStringSync());

    //TODO uncomment when found a sub implementation
    // What is the question we are trying to answer?
    // Testing if my algorithm works for file upload

    //var artefact = _storage.ref().child(familyId).child(artefactId).putFile(file);
    return _db
        .collection('families')
        .document(familyId)
        .collection('artefacts')
        .document(artefactId)
        .setData({'downloadUrl': url});


  }

  //TODO add firebase storage
  /// Get a stream of a single document
  Stream<ArtefactItem> streamArtefact(String famId, String id) {
    return _db
        .collection('families')
        .document(famId)
        .collection('artefacts')
        .document(id)
        .snapshots()
        .map((snap) => ArtefactItem.fromFirestore(snap));
  }

  Future<void> removeArtefact(FirebaseUser user, String id, dynamic family) {
    //TODO implement delete on firebase storage, useful code below, modify as needed:
    /* StorageReference storageReferance = FirebaseStorage.instance.ref();
    storageReference.child(filePath).delete().then((_) => print('Successfully deleted $filePath storage item' ));
*/

    return _db
        .collection('families')
        .document(family)
        .collection('artefacts')
        .document(id)
        .delete();
  }


  /// Query a subcollection
  Stream<List<Family>> streamFamilies(FirebaseUser user) {
    var ref = _db.collection('families').where('creator', isEqualTo: user.uid);

    return _db.collection('families').where('creator', isEqualTo: user.uid).snapshots().map((list) =>
        list.documents.map((doc) => Family.fromFirestore(doc)).toList());
    // TO-DO
  }

}