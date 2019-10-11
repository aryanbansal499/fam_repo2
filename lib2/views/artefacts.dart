//TODO artefacts list page
/* needs StreamProvider of artefact list */

//TODO artefacts singular view
/* needs artefact id and family id to be passed*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thebugs_prototype/models/ArtefactItem.dart';
import 'package:thebugs_prototype/models/artefactViewModel.dart';
import 'package:thebugs_prototype/services/middleware.dart';

import 'SingularArtefactView.dart';
import 'forms.dart';

class ArtefactsView extends StatelessWidget {
  @override

  final db = DatabaseService();

  Widget build(BuildContext context) {
    // TODO: implement build
    var vm = Provider.of<ArtefactViewModel>(context);
    var user = Provider.of<FirebaseUser>(context);
    var artefactId;

    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
                child: Text('Add artefact'),
                onPressed: () {
                  //TODO route to upload page with user and fam id uncomment when form is integrated
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ImageCapture(user: user, familyId: vm.matchId)));
                  //TODO move below to form page on submit
                 /* var artefact = db.addArtefactFirestore(user, {
                'artefactLink': 'collection/doc', //
                'type': artefactType.IMG.toString(),
                //'date': new DateTime.now(), //TODO change to year?
                'description': 'the beginning of many tests',
                'name': 'testing',
                'tags': ['#test'],
                'uploader': user.uid,
                'familyId': vm.matchId,
                }
                , vm.matchId);*/

                  //TODO reevaluate where the saving of downloadurl gets saved
                  // call add to storage with the artefact id
                  // fetch the document id and add artefact to firebase storage
                  /*artefact.then((onValue) async {
                print(onValue.documentID);
                artefactId = onValue.documentID;
                db.addArtefactStorage(vm.matchId, onValue.documentID);
                }
              );*/


                }),

            /*StreamProvider<List<ArtefactItem>>.value(
            stream: db.streamArtefacts(user, vm.matchId),
            child: new ArtefactsList(),
          ),*/
          ]
      ),
    );
  }
//print(artefact);
}

class ArtefactsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var artefacts = Provider.of<List<ArtefactItem>>(context);
    var user = Provider.of<FirebaseUser>(context);

    if (artefacts == null){
      return new Container();
    }

    //TODO display image instead - get downloadurl - add onTap - navigate to SingularArtefactView
    return Container(
      height: 300,
      // arg  below should equal to artefact.downloadUrl
      //child: Image.network('https://firebasestorage.googleapis.com/v0/b/thebug-test.appspot.com/o/2019-10-01%2012%3A57%3A02.154417.png?alt=media&token=10f859ae-e1ce-4a04-9286-a1420294492d')
      child: ListView(
        children: artefacts.map((artefact) {
          return Card(
            child: ListTile(
              title: Text(artefact.name),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SingularArtefactView(artefact: artefact)));
              }
            ),
          );
        }).toList(),
      ),
    );
  }
}