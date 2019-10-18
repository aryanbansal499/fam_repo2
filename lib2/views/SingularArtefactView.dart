import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/ArtefactItem.dart';



class SingularArtefactView extends StatefulWidget {

  // The framework calls createState the first time a widget appears at a given
  // location in the tree. If the parent rebuilds and uses the same type of
  // widget (with the same key), the framework re-uses the State object
  // instead of creating a new State object.
  final ArtefactItem artefact;
  final String family;

  SingularArtefactView({Key key, @required this.artefact, this.family}) : super(key: key);

  @override
  _SingularArtefactViewState createState() => _SingularArtefactViewState(artefact, family);
}

class _SingularArtefactViewState extends State<SingularArtefactView> {

  ArtefactItem artefact;
  final String family;
  _SingularArtefactViewState(this.artefact, this.family);


  void _handleChange() {
    setState(() {
      // When a user changes what's in the cart, you need to change
      // _shoppingCart inside a setState call to trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.
    });

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text(artefact.name + " - " + family), //Must be fetched
          ),
          body: Stack(
            children: <Widget>[
              //new Background(),
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
                      ),
                      new SizedBox(
                        width: 16.0,
                      ),
                      new Icon(
                        FontAwesomeIcons.comment,
                      ),
                      new SizedBox(
                        width: 16.0,
                      ),
                      new Icon(FontAwesomeIcons.paperPlane),
                    ],
                  ),
                  new Icon(FontAwesomeIcons.bookmark)
                ],
              ),
              Text(
                artefact.name,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
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
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                artefact.date.toString(),
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
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