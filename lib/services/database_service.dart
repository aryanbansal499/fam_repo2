// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:async';

// import 'package:fam_repo2/models/ArtefactItem.dart';
// import 'package:fam_repo2/models/Family.dart';
// import 'package:fam_repo2/models/Profile.dart';

// class DatabaseService {
//   final Firestore _db = Firestore.instance;

//   Future<Profile> getProfile(String id) async {
//     var snap = await _db.collection('users').document(id).get();

//     return Profile.fromMap(snap.data);
//   }

//   /// Get a stream of a single document
//   Stream<Profile> streamUser(String id) {
//     return _db
//         .collection('users')
//         .document(id)
//         .snapshots()
//         .map((snap) => Profile.fromMap(snap.data));
//   }

//   /// Query a subcollection
//   Stream<List<ArtefactItem>> streamArtefacts(FirebaseUser user, String famId) {
//     //TODO make the family input dynamic
//     var ref = _db.collection('artefacts').where('familyId', isEqualTo: famId);
//     // TO-DO;

//     //TODO show images instead of text list
//     return ref.snapshots().map((list) =>
//         list.documents.map((doc) => ArtefactItem.fromFirestore(doc)).toList());

//   }

//   Future<void> createUser(FirebaseUser user) {
//     return _db
//         .collection('users')
//         .document(user.uid)
//         .setData({
//       'name': 'Tester need to save from form ${user.uid.substring(0,5)}'
//       , 'description': 'get from profile'
//       , 'email': 'get from form'
//       , 'families': ['test1']
//       , 'private': true
//       , 'username': 'tester'});
//   }

//   Future<void> signOut(auth) async {
//     return auth.signOut();
//   }


//   Future<void> addFamily(FirebaseUser user, dynamic family) {
//     //get family uid and link to collection into families array
//     //_db.collection('users').document(user.uid).setData(data)
//     //List<String> fams =  _getFamilies(user);
//     //fams.add('test');
//     return _db
//         .collection('families')
//         .add(family); // uncomment when not prototyping
//   }

//   Future<void> addArtefact(FirebaseUser user, dynamic artefact, dynamic family) {
//     return _db
//         .collection('artefacts')
//         .add(artefact);
//   }

//   Future<void> removeArtefact(FirebaseUser user, String id, dynamic family) {
//     return _db
//         .collection('artefacts')
//         .document(id)
//         .delete();
//   }


//   /// Query a subcollection
//   Stream<List<Family>> streamFamilies(FirebaseUser user) {
//     var ref = _db.collection('families').where('creator', isEqualTo: user.uid);

//     return _db.collection('families').where('creator', isEqualTo: user.uid).snapshots().map((list) =>
//         list.documents.map((doc) => Family.fromFirestore(doc)).toList());
//     // TO-DO
//   }

// }