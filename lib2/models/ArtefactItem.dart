import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'Profile.dart';

class ArtefactItem /*extends StatelessWidget*/ {

  // artefact is passed as argument by onTap from Home view
  /*final Image image;
  final String name;
  final String family;
  final String description; // Can be audio as well
  final DateTime date;
  final String tags;
  final String comments; // As its own class

  ArtefactItem(this.image, this.name, this.family, this.description,
      this.date, this.tags, this.comments);


  @override
  Widget build(BuildContext context) {
    return image;
  }*/

  final String artefactLink;
  final artefactType type;
  final Timestamp date;
  final String description;
  final String name;
  final List<dynamic> tags;
  final String uploaderId;
  final String downloadUrl;
  final String familyId;
  final String id;

  ArtefactItem({this.artefactLink, this.type, this.date,
    this.description, this.name, this.tags, this.uploaderId,
    this.downloadUrl, this.familyId, this.id});

  String get famId {
    return familyId;
  }

  factory ArtefactItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return ArtefactItem(
        artefactLink: data['artefactLink'],
        type: data['artefactType'],
        date: data['date'],
        description: data['description'],
        name: data['name'],
        tags: data['tags'],
        uploaderId: data['uploaderId'],
        familyId: data['familyId'],
        downloadUrl: data['downloadUrl'],
        id: doc.documentID
    );
  }
}


enum artefactType  { AUD, IMG, VID, TXT}