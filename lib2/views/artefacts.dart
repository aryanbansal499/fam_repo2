//TODO artefacts singular view
/* needs artefact id and family id to be passed*/

//TODO make artefacts view into a grid

import 'package:flutter/material.dart';

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

  var scrollController = new ScrollController();
   bool gridView = false;
   bool listView = true;
   bool getGridViewState()
    {
      return gridView;
    }

    void setGridViewState(bool view)
    {
      gridView = view;

    }

    bool getListViewState()
    {
      return listView;
    }

    void setListViewState(bool view)
    {
      listView = view;

    }

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
          child: ArtefactsList(gridView,listView),
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  controller: scrollController,
                  children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        margin: EdgeInsets.all(0),
                        child: ArtefactsHeader()),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        margin: EdgeInsets.all(0),
                        child: ButtonBar
                        (
                          mainAxisSize: MainAxisSize.min,
                          alignment: MainAxisAlignment.start,
                          children: <Widget>
                          [
                            IconButton(icon: Icon(Icons.list),alignment: Alignment.topLeft, onPressed:(){setGridViewState(false); setListViewState(true);} ),
                            FlatButton(),
                            FlatButton(),
                            IconButton(icon: Icon(Icons.grid_on), onPressed:(){setGridViewState(true); setListViewState(false);} )
                          ],
                        ),
                      ),
                      StreamProvider<List<ArtefactItem>>.value(
                        stream: db.streamArtefacts(user, vm.matchId),
                        child: Container(
                          decoration: BoxDecoration(
                            //color: Colors.brown,
                          ),
                          child: ArtefactsList(getGridViewState(),getListViewState()),
                        )
                      ),
                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[*/
                          /*Column(
                            //height: MediaQuery.of(context).size.height * 0.2,
                            //margin: EdgeInsets.all(0),
                              children: <Widget>[ArtefactsHeader()]),
                          StreamProvider<List<ArtefactItem>>.value(
                              stream: db.streamArtefacts(user, vm.matchId),
                              child: Container(
                                decoration: BoxDecoration(
                                  //color: Colors.black45,
                                ),
                                child: ArtefactsList(),
                              )
                          ),*/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
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
                        //]
                    ]),
                  ]
                )
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
  ArtefactsView av = ArtefactsView(); 
  bool listView;
  bool gridView;
  ArtefactsList(this.gridView, this.listView); 
  Widget build(BuildContext context) {
    var artefacts = Provider.of<List<ArtefactItem>>(context);
    var user = Provider.of<FirebaseUser>(context);
    var fam = Provider.of<Family>(context);

    if (artefacts == null) {
      return new Container();
    }

    //TODO display image instead - get downloadurl - add onTap - navigate to SingularArtefactView
   /* return Container(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.55,
        // arg  below should equal to artefact.downloadUrl
        //child: Image.network('https://firebasestorage.googleapis.com/v0/b/thebug-test.appspot.com/o/2019-10-01%2012%3A57%3A02.154417.png?alt=media&token=10f859ae-e1ce-4a04-9286-a1420294492d')
        child: ListView(
        scrollDirection: Axis.vertical,
        children: artefacts.map((artefact) {
          if (artefact == null || artefact.downloadUrl == null || artefact.downloadUrl==""){*/
    else {
      if(av.getListViewState())
      {
           print(listView);
           print(gridView);
      return Container(
      height: MediaQuery.of(context).size.height * 0.50,
      // arg  below should equal to artefact.downloadUrl
      //child: Image.network('https://firebasestorage.googleapis.com/v0/b/thebug-test.appspot.com/o/2019-10-01%2012%3A57%3A02.154417.png?alt=media&token=10f859ae-e1ce-4a04-9286-a1420294492d')
        
        child:ListView(
          
          shrinkWrap: true,
          children: artefacts.map((artefact) {
            if (artefact == null || artefact.downloadUrl == null){
            return new Container();
          }
          return 
          Container(
            margin:EdgeInsets.all(8.0),
            child: Card(

            color: Colors.transparent,
            margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
  
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Column(
              
               
              children: <Widget>[
               Container
              (
                
                width: 500,
                height: 300,
                padding: const EdgeInsets.all(8.0),
                child: Image.network(artefact.downloadUrl,fit: BoxFit.fill,),
              ),

               ListTile
                (
                title: Text(artefact.name),
                onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => StreamProvider<ArtefactItem>.value(
                          stream: db.streamArtefact(fam.id, artefact.id),
                          child: SingularArtefactView(fam),
                        )));
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
              
               )]
            ),
            ),
            
            //color: Colors.transparent,
            //Shivam work on CardView and SingularArtefactView.
            
          ),
          );
          
        }).toList(),
      ),
    );
    }

    else if( av.getGridViewState())
    {
    
      print("gridView is working");
      return new Container
      (
        child: GridView.count
        (
            shrinkWrap: true,
            children: artefacts.map((artefact) {
            if (artefact == null || artefact.downloadUrl == null){
            return new Container();
          }
          return Card(
            margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
            color: Colors.transparent,
            //Shivam work on CardView and SingularArtefactView.
            child: Column(
              //alignment: WrapAlignment.start,
              children: <Widget>[
              Container
              (
                padding: const EdgeInsets.all(8.0),
                child:Image.network(artefact.downloadUrl,),
              ),

               ListTile
                (
                title: Text(artefact.name),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => StreamProvider<ArtefactItem>.value(
                            stream: db.streamArtefact(fam.id, artefact.id),
                            child: SingularArtefactView(fam),
                          )));
              }
              )
              
              ]
            ),
          );
        }).toList(), crossAxisCount: 2, 
          


        )


          

      );
    }
  }
    //TODO display image instead - get downloadurl - add onTap - navigate to SingularArtefactView
   
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
    /*return Container(
      /*decoration: new BoxDecoration(border:
        Border(
          bottom: BorderSide( //                   <--- left side
          color: Colors.black45,
          width: 3.0,)
        ),
      ),*/
      // family name
      // family description
      padding: EdgeInsets.fromLTRB(30, 10, 30, 20),
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(fam.name,
            style: TextStyle(fontSize: 30,
                letterSpacing: 3,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(100, 3, 47, 1)),),
            Text(fam.description, style: TextStyle(
                fontSize: 18,
                fontFamily: FontNameSubtitle,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: IconOnAppBarColour),)
          ],
      )
    ));*/
    return ListView(
        children:
        [
         
              Column
              (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>
                [
                  Container(
                    /*decoration: new BoxDecoration(border:
        Border(
          bottom: BorderSide( //                   <--- left side
          color: Colors.black45,
          width: 3.0,)
        ),
      ),*/
                    // family name
                    // family description
                    padding: EdgeInsets.fromLTRB(15, 0, 30, 20),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.55,
                    child: SingleChildScrollView(
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(fam.name,
                            style: TextStyle(fontSize: 30,
                                letterSpacing: 3,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(100, 3, 47, 1)),),
                          Text(fam.description, style: TextStyle(
                              fontSize: 18,
                              fontFamily: FontNameSubtitle,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: IconOnAppBarColour),)
                        ],
                      ),
                    )),
                  //Text(fam.description)
                ],
              ),
        ]
    );
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
