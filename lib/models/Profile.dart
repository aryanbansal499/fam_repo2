import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Family.dart';

class Profile {

  final String name;
  final String username;
  final String email;
  final String profileDesc;
  final bool isPrivate;
  final List<Family> families;
  final String id;
  //final Image dp;

  /*
  Profile(this.name, this.username, this.email, this.profileDesc, this.isPrivate, this.dp);

  @override
  Widget build(BuildContext context) {
    return dp;
  } */

  Profile({ this.name, this.username, this.email, this.profileDesc, this.isPrivate, this.families, this.id });

  factory Profile.fromDocument(DocumentSnapshot doc) {
    return Profile(
      name: doc['name'] ?? '',
      username: doc['username'] ?? '',
      email: doc['email'] ?? '',
      profileDesc: doc['description'] ?? '',
      isPrivate: doc['private'] ?? true,
      families: doc['families'],
    );
  }
}