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

  factory Profile.fromMap(Map data) {
    return Profile(
      name: data['name'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      profileDesc: data['description'] ?? '',
      isPrivate: data['private'] ?? true,
      families: data['families'],
    );
  }
}