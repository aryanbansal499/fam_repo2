//TODO accept and handle firebase user

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thebugs_prototype/models/Profile.dart';



class ProfileSettings extends StatefulWidget {

  // The framework calls createState the first time a widget appears at a given
  // location in the tree. If the parent rebuilds and uses the same type of
  // widget (with the same key), the framework re-uses the State object
  // instead of creating a new State object.
  final User profile;

  ProfileSettings({Key key, @required this.profile}) : super(key: key);

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState(profile);
}

class _ProfileSettingsState extends State<ProfileSettings> {

  User profile;
  _ProfileSettingsState(this.profile);


  void _handleChange() {
    setState(() {
      // When a user changes what's in the cart, you need to change
      // _shoppingCart inside a setState call to trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(profile.name), //Must be fetched
      ),
      body: (
          ListView(children: [
            ListTile(title: Text("Edit Profile Description")),
            ListTile( title: Text("Private Account"),
                trailing: Icon((FontAwesomeIcons.toggleOff))

            ),
            ListTile(title: Text("Sign out")),
          ])
      ),
    );
  }
}