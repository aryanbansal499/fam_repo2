import 'package:flutter/material.dart';
import 'dart:io';

class ImageBanner extends StatelessWidget {
  final File _imageFile;

  ImageBanner(this._imageFile);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.transparent),
        padding: EdgeInsets.all(32.0),
        child: Image.file(
          _imageFile,
          fit: BoxFit.fill,
        ));
  }
}