//TODO artefacts singular view
/* needs artefact id and family id to be passed*/

//TODO make artefacts view into a grid

import '../models/background.dart';
import '../style.dart';
import '../views/upload_page3.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ArtefactItem.dart';
import '../models/Family.dart';
import '../models/artefactViewModel.dart';
import '../services/middleware.dart';
import 'SingularArtefactView.dart';
import 'artefactForm.dart';
import 'settings.dart';

class ArtefactsView extends StatelessWidget {
  @override

  final db = DatabaseService();

  Widget build(BuildContext context) {
    // TODO: implement build
    var vm = Provider.of<ArtefactViewModel>(context);
    var user = Provider.of<FirebaseUser>(context);
    var fam = Provider.of<Family>(context);
    var artefactId;

    return MultiProvider(
      providers: [
        StreamProvider<Family>.value(
          stream: db.streamFamily(fam.id),
          child: ArtefactsHeader(),
        ),
          StreamProvider<Family>.value(
          stream: db.streamFamily(fam.id),
          child: ArtefactsList(),
          )
    ],
      child: Stack(
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
            appBar: PreferredSize(child: _MyAppBar(fam.id), preferredSize: Size.fromHeight(60.0)),
            body: Stack(
              children: <Widget>[
                //Background(),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        margin: EdgeInsets.all(0),
                        child: ArtefactsHeader()),
                      StreamProvider<List<ArtefactItem>>.value(
                        stream: db.streamArtefacts(user, vm.matchId),
                        child: Container(
                          decoration: BoxDecoration(
                            //color: Colors.black45,
                          ),
                          child: ArtefactsList(),
                        )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                              FloatingActionButton(
                                backgroundColor: IconOnAppBarColour,
                              child: Icon(Icons.add),
                              onPressed: () {
                                //TODO route to upload page with user and fam id uncomment when form is integrated
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => UploadPage2(user: user, familyId: vm.matchId)));
                                    //MaterialPageRoute(builder: (context) => ImageCapture(user: user, familyId: vm.matchId)));
                              }),
                            ],
                      ),

                    ]
                ),
              ],

            ),
          ),
        ],
      ),
    );
  }
//print(artefact);
}

class ArtefactsList extends StatelessWidget {
  @override
  final db = DatabaseService();

  Widget build(BuildContext context) {
    var artefacts = Provider.of<List<ArtefactItem>>(context);
    var user = Provider.of<FirebaseUser>(context);
    var fam = Provider.of<Family>(context);

    if (artefacts == null){
      return new Container();
    }

    //TODO display image instead - get downloadurl - add onTap - navigate to SingularArtefactView
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      // arg  below should equal to artefact.downloadUrl
      //child: Image.network('https://firebasestorage.googleapis.com/v0/b/thebug-test.appspot.com/o/2019-10-01%2012%3A57%3A02.154417.png?alt=media&token=10f859ae-e1ce-4a04-9286-a1420294492d')
      child: ListView(
        scrollDirection: Axis.vertical,
        children: artefacts.map((artefact) {
          if (artefact == null || artefact.downloadUrl == null){
            return new Container();
          }
          return Card(
            color: Colors.transparent,
            //shape: ShapeBorder.lerp(a, b, t),
            //Shivam work on CardView and SingularArtefactView.
            child: ListTile(
              leading: Image.network(artefact.downloadUrl),
              title: Text(artefact.name),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SingularArtefactView(artefact: artefact, family: fam.name)));
              },
              trailing: Container(
                child: IconButton(
                  icon: Icon(Icons.delete),
                  color: IconOnCardColour,
                  onPressed: (){
                    //TODO add a are you sure alert dialog box
                    //TODO remove from db
                    db.removeArtefact(artefact.id, fam.id);
                  },
                )
              )
            ),
          );
        }).toList(),
      ),
    );
  }
}


class ArtefactsHeader extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    var fam = Provider.of<Family>(context);
    // TODO: implement build
    if (fam == null){
      return new Container();
    }
    return Container(
      /*decoration: new BoxDecoration(border:
        Border(
          bottom: BorderSide( //                   <--- left side
          color: Colors.black45,
          width: 3.0,)
        ),
      ),*/
      // family name
      // family description
      padding: EdgeInsets.all(40.0),
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(fam.name),
            Text(fam.description)
          ],
      )
    ));
  }

}

class _MyAppBar extends StatelessWidget {
  final db = DatabaseService();
  final String family;

  _MyAppBar(this.family);

  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    //User userProfile;

    db.getProfile(user.uid).then((onValue) async {
      //userProfile = await onValue;
    });

    return AppBar(
      title: Center( child: Text('ARTEFACTS')),
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: IconOnAppBarColour, //change your color here
      ),
      elevation: 0,
      actions: [
        IconButton(
            icon: Icon(Icons.settings, color: IconOnAppBarColour,),
            //TODO change onpressed to go to FamilySettings
            onPressed: () {Navigator.push(context,
                MaterialPageRoute(builder: (context) =>
                StreamProvider<Family>.value(
                  stream: db.streamFamily(family),
                  child: FamilySettings(),
                )));
            }
        ),
      ],
    );
  }
  
}
