import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thebugs_prototype/views/auth.dart';
import 'package:thebugs_prototype/views/home.dart';

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
          Provider(builder: (context) => Auth()),
          //Provider(builder: (context) => ArtefactsView())
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          initialRoute: '/',
          routes: {
            '/': (context) => Home(),
            '/auth': (context) => Auth(),
            //'/artefacts': (context) => ArtefactsView(),
            //'/upload': (context) => UploadPage2()
            // TODO add profile, settings, upload, edit routes
          },
        )
    );
  }
}

