//TODO accept and handle firebase user
//TODO add change password
//TODO add delete account
//TODO add a familySettings class
//TODO remove make account private - since the app is private

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/Family.dart';
import '../models/Profile.dart';
import '../models/background.dart';
import '../models/icon_button.dart';
import '../services/middleware.dart';
import '../style.dart';
import 'artefactForm.dart';
import 'edit_page3.dart';
import 'familyForm.dart';



class ProfileSettings extends StatefulWidget {

  // The framework calls createState the first time a widget appears at a given
  // location in the tree. If the parent rebuilds and uses the same type of
  // widget (with the same key), the framework re-uses the State object
  // instead of creating a new State object.
  final User profile;

  ProfileSettings({Key key, @required this.profile}) : super(key: key);

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState(profile);
}

class _ProfileSettingsState extends State<ProfileSettings> {

  User profile;
  _ProfileSettingsState(this.profile);

  final db = DatabaseService();
  final auth = FirebaseAuth.instance;

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
        new Container(
          height: double.infinity,
          width: double.infinity,
          decoration:new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("images/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomPadding: false,
          appBar: PreferredSize(
              child:  AppBar(
                title: Text(profile.username.toUpperCase()),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(
                  color: IconOnCardColour, //change your color here
                ),
        ),
              preferredSize: Size.fromHeight(60.0)),
          //backgroundColor: Colors,
          body: Scaffold(
            backgroundColor: Colors.white70,
            body:
              Stack(
                children: <Widget>[
                  ListView(
                      children: [
                        /*ListTile(
                            title: Text("Edit Profile Description",
                            style: TextStyle(fontFamily: FontNameSubtitle,
                            fontWeight: FontWeight.bold,))),*/
                        /*ListTile( title: Text("Private Account"),
                            trailing: Icon((FontAwesomeIcons.toggleOff))

                        ),*/
                        ListTile(
                            title: Text("Sign out",
                            style: TextStyle(fontFamily: FontNameSubtitle,
                            fontWeight: FontWeight.bold,),),
                            onTap: () {
                              db.signOut(auth);
                              Navigator.pushNamed(context, '/');
                            }),
                      ]
                  ),
                ],
              ),
          ),
        ),
      ],
    );
  }
}

class FamilySettings extends StatelessWidget {
  final db = DatabaseService();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //get provider for family
    var family = Provider.of<Family>(context);

    return Stack(
      children: <Widget>[
        new Container(
          height: double.infinity,
          width: double.infinity,
          decoration:new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("images/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomPadding: false,
          appBar: PreferredSize(
              child:  AppBar(
                title: Text(family.name.toUpperCase()),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(
                  color: IconOnCardColour, //change your color here
                ),
              ),
              preferredSize: Size.fromHeight(60.0)),
          //backgroundColor: Colors,
          body: Scaffold(
            backgroundColor:Colors.white70,
            body:
            Stack(
              children: <Widget>[
                (
                ListView(
                    children: [
                      FamilyEditAlertDialog(family), //TODO return Future user
                      ListTile(
                          title: Text("Sign out",
                            style: TextStyle(fontFamily: FontNameSubtitle,
                            fontWeight: FontWeight.bold,)),
                          onTap: () {
                            db.signOut(auth);
                            Navigator.pushNamed(context, '/');
                          }),
                    ])
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ArtefactSettings extends StatelessWidget {

  final artefact;
  final famId;

  ArtefactSettings({Key key, this.artefact, this.famId}) : super(key: key);

  final db = DatabaseService();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Stack(
      children: <Widget>[
        new Container(
          height: double.infinity,
          width: double.infinity,
          decoration:new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("images/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomPadding: false,
          appBar: PreferredSize(
              child:  AppBar(
                title: Text(artefact.name.toUpperCase()),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(
                  color: IconOnCardColour, //change your color here
                ),
              ),
              preferredSize: Size.fromHeight(60.0)),
          //backgroundColor: Colors,
          body: Scaffold(
            //backgroundColor:
            body:
            Stack(
              children: <Widget>[
                (
                    ListView(
                        children: [
                          //FamilyEditAlertDialog(family), //TODO return Future user
                          ArtefactEditAlertDialog(artefact, famId),
                          ListTile(
                              title: Text("Sign out"),
                              onTap: () {
                                db.signOut(auth);
                                Navigator.pushNamed(context, '/');
                              }),
                        ])
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}