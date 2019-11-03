import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ArtefactItem {

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

}

enum artefactType  { AUD, IMG, VID, TXT}
