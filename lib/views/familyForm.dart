import 'package:flutter/material.dart';

import '../services/middleware.dart';

class FamilyTextFieldAlertDialog extends StatelessWidget {
  TextEditingController _textFieldController = TextEditingController();

  String _description;
  String _familyName;
  final formKey = GlobalKey<FormState>();

  final db = DatabaseService();
  final user;

  FamilyTextFieldAlertDialog(this.user);

  bool validate() {
    final form = formKey.currentState;
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
            title: Text('Add a family collection'),
            content: Form(
              key: formKey,
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
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('SUBMIT'),
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
          child: Icon(Icons.add),
          //color: Colors.red,
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
