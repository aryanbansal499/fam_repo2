import 'package:flutter/material.dart';

import '../services/middleware.dart';
import '../style.dart';
import '../views/auth.dart';

class FamilyTextFieldAlertDialog extends StatelessWidget {
  TextEditingController _textFieldController = TextEditingController();

  String _description;
  String _familyName;
  final _formKey = GlobalKey<FormState>();
  DialogBox dialogBox = new DialogBox();

  final db = DatabaseService();
  final user;

  FamilyTextFieldAlertDialog(this.user);
  bool validate() {
    final form = _formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {

      } catch (e) {
        print(e);
        // TODO validation needs implementation
        //dialogBox.imformation(context, "Error ",e.toString());
      }
    }
  }


  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add a family collection',
              style: TextStyle(fontFamily: FontNameSubtitle,
              fontWeight: FontWeight.bold,)),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    validator: StringValidator.validate,
                    decoration: InputDecoration(hintText: "Family name"),
                    onSaved: (value) => _familyName = value,
                  ),
                  TextFormField(
                    validator: StringValidator.validate,
                    decoration: InputDecoration(hintText: 'Family description'),
                    onSaved: (value) => _description = value,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL',
                  style: TextStyle(fontFamily: FontNameSubtitle,
                    fontWeight: FontWeight.bold,)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('SUBMIT',
                style: TextStyle(fontFamily: FontNameSubtitle,
                fontWeight: FontWeight.bold,)),
                onPressed: () {
                  //TODO validate submission
                  submit();
                  //TODO call db

                  db.addFamily(user, {'name': _familyName, 'creator': user.uid, 'description': _description});
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
          child: Icon(Icons.add,),
          backgroundColor: IconOnAppBarColour,
          onPressed: () => _displayDialog(context),
        );
  }
}

class StringValidator {
  static String validate(String value)
  {
    return value.isEmpty ? "Text field can't be empty " : null;
  }
}

class FamilyEditAlertDialog extends StatelessWidget {
  TextEditingController _textFieldController = TextEditingController();

  //TODO refactor for editing the family name and description

  String _description;
  String _familyName;
  final _formKey = GlobalKey<FormState>();

  final db = DatabaseService();
  final family;

  FamilyEditAlertDialog(this.family);

  bool validate() {
    final form = _formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {

      } catch (e) {
        print(e);
      }
    }
  }


  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Udate family description',
              style: TextStyle(fontFamily: FontNameSubtitle,
              fontWeight: FontWeight.bold,)),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    validator: StringValidator.validate,
                    decoration: InputDecoration(
                      hintText: family.description),
                    onSaved: (value) => _description = value,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL',
            style: TextStyle(fontFamily: FontNameSubtitle,
              fontWeight: FontWeight.bold,)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('SUBMIT',
                style: TextStyle(fontFamily: FontNameSubtitle,
                fontWeight: FontWeight.bold,)),
                onPressed: () {
                  //TODO validate submission
                  submit();
                  //TODO call db
                  db.editFamilyDescription(family, _description);

                  //TODO edit family, update data
                  //db.addFamily(user, {'name': _familyName, 'creator': user.uid, 'description': _description});
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Edit Family Description",
        style: TextStyle(fontFamily: FontNameSubtitle,
        fontWeight: FontWeight.bold,)),
      onTap: () => _displayDialog(context),
    );
  }
}
