import 'package:fam_repo2/Upload.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'provider.dart';
import 'screens/upload_page2.dart';

class HomePage extends StatefulWidget {


   _HomePageState createState() => _HomePageState();
}
    
class _HomePageState extends State<HomePage> 
{

  List<Choice> choices = const <Choice>[
    const Choice( title: 'Jaipur Royal Family', date : 'The family is a descendent of the rulers who ruled Jaipur in the last millennium',  description: 'The family is a descendent of the rulers who ruled Jaipur in the last millennium', imglink:'https://i.pinimg.com/originals/8a/61/4f/8a614ff5e364173ef8ee1b7af19b3730.jpg'),
    //const Choice(title: 'MacBook Air', date : '1 June 2016',  description: 'MacBook Air is a line of laptop computers developed and manufactured by Apple Inc. It consists of a full-size keyboard, a machined aluminum case, and a thin light structure.', imglink:'https://images.unsplash.com/photo-1499673610122-01c7122c5dcb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60'),
    //const Choice(title: 'iMac', date : '1 June 2019', description: 'iMac is a family of all-in-one Macintosh desktop computers designed and built by Apple Inc. It has been the primary part of Apple consumer desktop offerings since its debut in August 1998, and has evolved through seven distinct forms.', imglink:'https://images.unsplash.com/photo-1517059224940-d4af9eec41b7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60'),
    //const Choice(title: 'Mac Mini', date : '1 June 2017',description: 'Mac mini (branded with lowercase "mini") is a desktop computer made by Apple Inc. One of four desktop computers in the current Macintosh lineup, along with the iMac, Mac Pro, and iMac Pro, it uses many components usually featured in laptops to achieve its small size.', imglink:'https://www.apple.com/v/mac-mini/f/images/shared/og_image__4mdtjbfhcduu_large.png?201904170831'),
    //const Choice(title: 'Mac Pro', date : '1 June 2018',description: 'Mac Pro is a series of workstation and server computer cases designed, manufactured and sold by Apple Inc. since 2006. The Mac Pro, in most configurations and in terms of speed and performance, is the most powerful computer that Apple offers.', imglink:'https://i0.wp.com/9to5mac.com/wp-content/uploads/sites/6/2017/01/mac-pro-2-concept-image.png?resize=1000%2C500&quality=82&strip=all&ssl=1'),
  ];



  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DashBoard'),
        backgroundColor: Colors.brown,
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
      body: 
      DecoratedBox
      (
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          color: Colors.red,
          image: DecorationImage(
              image: AssetImage('images/bg.png'),
              fit: BoxFit.cover),
      ),
        child: new Container
          (
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(20.0),
              children: List.generate(choices.length, (index) {
                  return Center(
                    child: ChoiceCard(choice: choices[index], item: choices[index]),
                  );
              }
            )

          ),
        ),
      ),
       
        bottomNavigationBar : new BottomAppBar
          (
            color : Colors.brown,
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
                          return new UploadPage2();

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
class Choice {
  final String title;
  final String date;
  final String description;
  final String imglink;

  const Choice({this.title, this.date, this.description, this.imglink});
}


class ChoiceCard extends StatelessWidget {
  const ChoiceCard(
      {Key key, this.choice, this.onTap, @required this.item, this.selected: false}
    ) : super(key: key);
 
  final Choice choice;
  final VoidCallback onTap;
  final Choice item;
  final bool selected;
 @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.display1;
    if (selected)
      textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
        return Card(
          color: Colors.white,
          child: Column(
              children: <Widget>[
                new Container( 
                  padding: const EdgeInsets.all(8.0),
                  child: 
                  Image.network(
                    choice.imglink
                  )),
                  new Container( 
                  padding: const EdgeInsets.all(10.0),
                  child:                    
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(choice.title, style: Theme.of(context).textTheme.title),
                        Text(choice.date, style: TextStyle(color: Colors.black.withOpacity(0.5))),
                        Text(choice.description),
                      ],
                    ),
                    
                  )
            ],
           crossAxisAlignment: CrossAxisAlignment.start,
          )
    );
  }
}
