import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth.dart';

import 'style.dart';
import 'views/auth.dart';
import 'views/home.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<FirebaseUser>.value(
              stream: FirebaseAuth.instance.onAuthStateChanged
          ),
          //Provider(builder: (context) => Auth()),
          //Provider(builder: (context) => ArtefactsView())
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          //theme: ThemeData(cursorColor: Colors.brown,primarySwatch: Colors.brown),
          initialRoute: '/',

          theme: ThemeData(
              cursorColor: Colors.brown,
              primarySwatch: Colors.brown,
              appBarTheme: AppBarTheme(
                textTheme: TextTheme(title: AppBarTextStyle),
                color: Colors.transparent
              ),
              textTheme: TextTheme(
                title: SubtitleTextStyle
              ),
              fontFamily: "Adobe Song Std"),
          routes: {
            '/': (context) => Home(),
            //'/auth': (context) => Auth(),
            //'/artefacts': (context) => ArtefactsView(),
            //'/upload': (context) => UploadPage2()
            // TODO add profile, settings, upload, edit routes
          },
        )
    );
  }
}

