import 'package:flutter/material.dart';

class ArtefactItem extends StatelessWidget {

  // artefact is passed as argument by onTap from Home view
  final Image image;
  final String name;
  final String family;
  final String description; // Can be audio as well
  final DateTime date;
  final String tags;
  final String comments; // As its own class

  ArtefactItem(this.image, this.name, this.family, this.description,
      this.date, this.tags, this.comments,);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return image;
  }

}