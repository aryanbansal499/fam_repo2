//TODO homepage showing families

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thebugs_prototype/models/Family.dart';
import 'package:thebugs_prototype/models/Profile.dart';
import 'package:thebugs_prototype/models/artefactViewModel.dart';
import 'package:thebugs_prototype/services/middleware.dart';

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
    return Column(
      children: <Widget>[
        _MyAppBar(),
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(child: _FamiliesList()),
              RaisedButton(
                  child: Text('Add family'),
                  onPressed: () => db.addFamily(user, {'name': 'Testing', 'creator': user.uid})),
              RaisedButton(
                  child: Text('Create'),
                  onPressed: () => db.createUser(user)),
            ]
        ),
      ]
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

  var tapped;
  redirect(String id) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              builder: (context) => (ArtefactViewModel(viewType.family, id)),
              child: ArtefactsView()
          ),
        ],
        child: Auth()
    );
  }

  Widget build(BuildContext context) {
    var families = Provider.of<List<Family>>(context);

    if (families != null) {
      return Container(
        height: 300,
        child: ListView(
          children: families.map((family) {
            return Card(
              child: ListTile(
                //leading: Text(weapon.img, style: TextStyle(fontSize: 50)),
                title: Text(family.name),
                onTap: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Buffer(id: family.id)))
                },
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
      userProfile = onValue;
    });

    return AppBar(
      title: Text('user'),
      actions: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProfileSettings(
              profile: userProfile)));
          }
        ),
      ],
    );
  }

}
