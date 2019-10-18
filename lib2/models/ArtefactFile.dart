import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/image_banner.dart';
import '../models/video_banner.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../views/upload_page3.dart';
import 'ArtefactItem.dart';
import 'Profile.dart';

class ArtefactBanner extends StatelessWidget {
  final File _artefactFile;
  final artefactType _type;
  final FirebaseUser user;
  final String familyId;

  ArtefactBanner(this._artefactFile, this._type, this.user, this.familyId);

  @override
  Widget build(BuildContext context) {
    if(_artefactFile != null) {
      if (_type == artefactType.IMG ||
          _type == artefactType.GAL) {
        return ImageBanner(_artefactFile);
      }
      else if (_type == artefactType.VID) {
        return VideoBanner(_artefactFile);
      }
      else if(_type == artefactType.TXT) {
        //TODO: ADD ARYAN'S CODE HERE
        return Container();
      } else if(_type == artefactType.AUD) {
        return Container();
        //To
      }
    } else {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => UploadPage2(user: user,
                                                    familyId: familyId,)));
    }
  }


}


