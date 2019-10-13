import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Family.dart';

class User /*extends StatelessWidget*/ {

  final String name;
  final String username;
  final String email;
  final String profileDesc;
  final bool isPrivate;
  //final List<Family> families;
  final String id;
  //final Image dp;

  /*
  Profile(this.name, this.username, this.email, this.profileDesc, this.isPrivate, this.dp);

  @override
  Widget build(BuildContext context) {
    return dp;
  } */

  User({ this.name, this.username, this.email, this.profileDesc, this.isPrivate, /*this.families,*/ this.id });

  factory User.fromMap(Map data) {
    return User(
      name: data['name'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      profileDesc: data['description'] ?? '',
      isPrivate: data['private'] ?? true,
      //families: data['families'],
    );
  }
}