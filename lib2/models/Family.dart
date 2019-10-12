import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'ArtefactItem.dart';
import 'Profile.dart';


class Family extends ChangeNotifier{

  final String name;
  //final List<String> artefacts; //Investigate how to store artefact objects
  /*final List<String> subscribers;
  final List<String> admins;*/
  final String id;
  final String creator;
  final String description;

  Family( {this.name, /*this.artefacts, this.subscribers, this.admins,*/ this.id, this.creator, this.description } );

  factory Family.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    {
      return Family(
        name: data['name'] ?? '',
        //artefacts: data['artefacts'] ?? '',
        /*subscribers: data['subcribers'] ?? '',
        admins: data['admins'] ?? '',*/
        id: doc.documentID,
        creator: data['creator'],
        description: data['description']
      );
    }
  }
}