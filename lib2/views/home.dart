//TODO homepage showing families

import 'package:fam_repo2/background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../models/Family.dart';
import '../models/Profile.dart';
import '../models/artefactViewModel.dart';
import '../services/middleware.dart';
import '../style.dart';
import 'familyForm.dart';
import 'settings.dart';
import 'artefacts.dart';
import 'auth.dart';

class Home extends StatelessWidget {
  @override

  final db = DatabaseService();
  final auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);

    if (user == null){
      return Auth();
    }
    // TODO: implement build
    return
        Stack(
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
              resizeToAvoidBottomPadding: false,
              appBar: PreferredSize(
                child: _MyAppBar(),
                preferredSize: Size.fromHeight(60.0)),
                backgroundColor: Colors.transparent,
              body: Stack(
                children: <Widget>[
                  //Background(),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text('~',
                            style: TextStyle(
                              fontSize: 50,
                              color: accentColour
                            ),),
                            /*Row(children: <Widget>[
                              Text('Your families',
                                style: TextStyle(
                                  fontSize: LargeTextSize,
                                ),
                              textAlign: TextAlign.left,
                              ),
                            ],),*/
                            _FamiliesList()
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            FamilyTextFieldAlertDialog(user),
                                /*FloatingActionButton(
                                child: Icon(Icons.add),
                                //TODO redirect to family form
                                onPressed: () {
                                  return TextFieldAlertDialog();
                                  //db.addFamily(user, {'name': 'Testing', 'creator': user.uid});
                                })*/

                              ],
                        ),
                      ]
                  ),
                ],
              ),
            ),
          ],
        );
  }
}

class _FamiliesList extends StatelessWidget {
  final db = DatabaseService();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);

    return StreamProvider<List<Family>>.value(
      stream: db.streamFamilies(user),
      child: FamiliesList(),
    );
  }
}

class FamiliesList extends StatelessWidget {
  @override
  final db = DatabaseService();

  var tapped;
  redirect(String id) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              builder: (context) => (ArtefactViewModel(viewType.family, id)),
              child: ArtefactsView()
          ),
        ],
    );
  }

  Widget build(BuildContext context) {
    var families = Provider.of<List<Family>>(context);

    if (families != null) {
      return Container(
              height: MediaQuery.of(context).size.height * 0.61,
              child: ListView(
                children: families.map((family) {
                  //TODO insert UI here
                  return Card(
                    color: Colors.transparent,
                    child: ListTile(
                      //leading: TODO if want to add image or crest
                      title: Text(family.name,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontFamily: FontNameSubtitle,
                      fontWeight: FontWeight.bold,
                      color: IconOnCardColour,
                      fontSize: BodyTextSize+2,
                      letterSpacing: 3),),
                      onTap: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Buffer(id: family.id)))
                      },
                      leading : Container(
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          color: IconOnCardColour,
                          onPressed: (){
                            //TODO add a are you sure alert dialog box
                            //TODO remove from db
                            db.removeFamily(family.id);
                          },
                        )
                      )
                      ),
                  );
                }).toList(),
              ),
          );
    }
    return new Container();
  }
}

class Buffer extends StatelessWidget {
  @override

  final String id;

  const Buffer({Key key, this.id}) : super(key: key);

  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              builder: (context) => (ArtefactViewModel(viewType.family, id)),
              child: ArtefactsView()
          ),
          Provider(builder: (context) => Family(id: id))
        ],
        child: ArtefactsView()
    );;
  }

}

//TODO create app bar
class _MyAppBar extends StatelessWidget {
  final db = DatabaseService();

  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    User userProfile;

    db.getProfile(user.uid).then((onValue) async {
      userProfile = await onValue;
    });

    return AppBar(
      iconTheme: IconThemeData(
        color: IconOnCardColour, //change your color here
      ),
      title: Text('FAMILIES'),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.settings),
          color: IconOnAppBarColour,
          onPressed: () {Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProfileSettings(
              profile: userProfile)));
          }
        ),
      ],
    );
  }

}

//TODO add a bottom bar