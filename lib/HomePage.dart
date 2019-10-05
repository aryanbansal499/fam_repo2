import 'package:fam_repo2/Upload.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'provider.dart';

class HomePage extends StatefulWidget {


   _HomePageState createState() => _HomePageState();
}
    
class _HomePageState extends State<HomePage> 
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DashBoard'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text("Sign Out"),
            onPressed: () async {
              try {
                Auth auth = Provider.of(context).auth;
                await auth.signOut();
              } catch (e) {
                print(e);
              }
            },
          )
        ],
      ),
      body: new Container
        (

        ),
        bottomNavigationBar : new BottomAppBar
          (
            color : Colors.deepOrange,
            child: new Container
            (
              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: new Row 
              (
                mainAxisAlignment : MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,

                children: <Widget>
                [
                  new IconButton(
                    icon: new Icon(Icons.add_a_photo),
                    iconSize: 35,
                    color: Colors.white,

                    onPressed: ()
                    {
                      Navigator.push
                      (
                        context,
                        MaterialPageRoute(builder: (context)
                        {
                          return new UploadPage();

                        })

                      );
                    },
                  ),


                  new IconButton(
                    icon: new Icon(Icons.grid_on),
                    iconSize: 35,
                    color: Colors.brown,
                    onPressed: null,
                  ),

                  new IconButton(
                    icon: new Icon(Icons.mic),
                    iconSize: 35,
                    color: Colors.brown,
                    onPressed: null,
                  ),

                  new IconButton(
                    icon: new Icon(Icons.thumb_down),
                    iconSize: 35,
                    color: Colors.brown,
                    onPressed: null,
                  ),
                ]

              )

            ) 
          )
    );
  }
  
}