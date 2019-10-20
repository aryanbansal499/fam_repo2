import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/ArtefactItem.dart';
import '../models/background.dart';
import '../style.dart';
import 'settings.dart';



/*class SingularArtefactView extends StatefulWidget {

  // The framework calls createState the first time a widget appears at a given
  // location in the tree. If the parent rebuilds and uses the same type of
  // widget (with the same key), the framework re-uses the State object
  // instead of creating a new State object.
  final ArtefactItem artefact;
  final String family;

  SingularArtefactView({Key key, @required this.artefact, this.family}) : super(key: key);

  @override
  _SingularArtefactViewState createState() => _SingularArtefactViewState(family);
}*/

class SingularArtefactView extends StatelessWidget {

  //ArtefactItem artefact;
  final family;
  SingularArtefactView(this.family);


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

          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(
              color: IconOnCardColour, //change your color here
            ),
            elevation: 0,
            title: Text(family.name.toUpperCase()),
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
            ],//Must be fetched
          ),
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
                      new Icon(FontAwesomeIcons.share,
                        color: IconOnAppBarColour,),
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