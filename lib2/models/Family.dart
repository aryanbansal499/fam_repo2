import 'package:cloud_firestore/cloud_firestore.dart';

import 'ArtefactItem.dart';
import 'Profile.dart';


class Family {

  final String name;
  //final List<String> artefacts; //Investigate how to store artefact objects
  /*final List<String> subscribers;
  final List<String> admins;*/
  final String id;
  final String creator;

  Family( {this.name, /*this.artefacts, this.subscribers, this.admins,*/ this.id, this.creator } );

  factory Family.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    {
      return Family(
        name: data['name'] ?? '',
        //artefacts: data['artefacts'] ?? '',
        /*subscribers: data['subcribers'] ?? '',
        admins: data['admins'] ?? '',*/
        id: doc.documentID,
        creator: data['creator']

      );
    }
  }
}