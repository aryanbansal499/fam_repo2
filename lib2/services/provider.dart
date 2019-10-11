import 'package:flutter/material.dart';
import 'auth.dart';

class MyProvider extends InheritedWidget{
final BaseAuth auth;

MyProvider(
  {
    Key key,
    Widget child,
    this.auth,
  }) : super(
            key: key, 
            child: child,
      );

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static MyProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(MyProvider) as MyProvider );

  
}