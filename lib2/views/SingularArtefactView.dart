import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:image_picker_saver/image_picker_saver.dart';

import '../models/ArtefactItem.dart';
import '../models/Family.dart';
import '../models/background.dart';

import '../services/middleware.dart';
import '../style.dart';
import 'settings.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:http/http.dart' as http;


/*class SingularArtefactView extends StatefulWidget {

  // The framework calls createState the first time a widget appears at a given
  // location in the tree. If the parent rebuilds and uses the same type of
  // widget (with the same key), the framework re-uses the State object
  // instead of creating a new State object.
  final ArtefactItem artefact;
  final String family;
  final String familyId;

  SingularArtefactView({Key key, @required this.artefact, this.family,this.familyId}) : super(key: key);

  @override
  _SingularArtefactViewState createState() => _SingularArtefactViewState(family);
}*/

class SingularArtefactView extends StatelessWidget {

  //ArtefactItem artefact;
  final family;
  SingularArtefactView(this.family);


  shareFile(ArtefactItem artefact) async
  {
    var response = await http.get(artefact.downloadUrl);
    var filePath = await ImagePickerSaver.saveFile(fileData: response.bodyBytes); 
    print(filePath);
    String BASE64_IMAGE = filePath;

    final ByteData bytes = await rootBundle.load(BASE64_IMAGE);
    await Share.file(artefact.id,artefact.name+'.jpg',bytes.buffer.asUint8List(),'image/png');
    //  var request = await HttpClient().getUrl(Uri.parse(artefact.downloadUrl));
    //  var response = await request.close();
    //  Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    //  await Share.file('ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg');

  }

  @override
  Widget build(BuildContext context) {
    var artefact = Provider.of<ArtefactItem>(context);

    if (artefact == null){
      return new Container();
    }

    return Stack(
      children: <Widget>[
        new Background(),
        Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.transparent,
          //
          appBar: PreferredSize(child: _MyAppBar(family, artefact), preferredSize: Size.fromHeight(60.0)),
          body: Stack(

            children: <Widget>[
              Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // if Image TODO modify as appropriate if audio/text/video
              Column (
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    new Container(

                      height: 400.0,
                      width: 410.0,
                      decoration: new BoxDecoration(
                        image: DecorationImage(
                          image: new NetworkImage(
                              artefact.downloadUrl),
                          fit: BoxFit.fill,
                        ),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                  ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Icon(
                        FontAwesomeIcons.heart,
                        color: IconOnAppBarColour,
                      ),
                      new SizedBox(
                        width: 16.0,
                      ),
                      /*new Icon(
                        FontAwesomeIcons.comment,
                        color: IconOnAppBarColour,
                      ),*/
                      new SizedBox(
                        width: 16.0,
                      ),
                      new IconButton(icon: Icon(FontAwesomeIcons.share, color:IconOnAppBarColour),onPressed: (){shareFile(artefact);},)
                    ],
                  ),
                  new Icon(FontAwesomeIcons.bookmark)
                ],
              ),
              Container(
                child: Column(
                  children: <Widget>[],
                ),
              ),
              Divider(
                height: 10.0,
                color: Colors.transparent,
              ),
              Text(
                artefact.name,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,
                  fontFamily: FontNameSubtitle,),
              ),
              Divider(
                height: 10.0,
                color: Colors.transparent,
              ),
              /*Text(
                artefact.family + " Family",
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),*/
              Text(
                artefact.description,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,
                    fontFamily: FontNameSubtitle),
              ),
              Divider(
                height: 10.0,
                color: Colors.transparent,
              ),
              Text(
                artefact.date,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,
                    fontFamily: FontNameSubtitle),
              ),
              Divider(
                height: 10.0,
              ),
              /*Text(
                artefact.tags,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),*/
              Expanded(
                child: new TextField(
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText: "Add a comment...",
                  ),
                ),
              ),
            ],
          ),
          ]
          )
        ),
      ],
    );
  }
  
}

class _MyAppBar extends StatelessWidget {
  final db = DatabaseService();
  final family;
  final artefact;

  _MyAppBar(this.family, this.artefact);

  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    //User userProfile;

    db.getProfile(user.uid).then((onValue) async {
      //userProfile = await onValue;
    });

    return AppBar(
      title: Center( child: Text(family.name)),
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: IconOnAppBarColour, //change your color here
      ),
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.edit, color: IconOnAppBarColour,),
          onPressed: (){
            // TODO go to artefact settings
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ArtefactSettings(artefact: artefact, famId: family.id))
            );
          },
        ),
      ],
    );
  }
}