import 'package:flutter/material.dart';
import 'package:fam_repo2/widgets/header.dart';

class CreateAccount extends StatefulWidget
{
  @override
  _CreateAccountState createState() => _CreateAccountState();
  
}

class _CreateAccountState extends State<CreateAccount>
{
  String username;
  final _formKey = GlobalKey<FormState>();

  submit()
  {
    _formKey.currentState.save();
    Navigator.pop(context,username);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold 
    (
      appBar: header(context,titleText:"set up your profile"),
      body: ListView
      (
        children: <Widget>
        [
          Container
          (
            child: Column(children: <Widget>
            [
              Padding
              (
                padding : EdgeInsets.only(top: 25.0),
                child: Center
                (
                  child: Text("Create a username", style: TextStyle(fontSize: 25.0) ,),
                ),
              ),
              Padding
              (
                padding: EdgeInsets.all(16.0),
                child: Container
                (
                  child: Form
                  (
                    key: _formKey,
                    child: TextFormField
                    (
                      onSaved: (val) => username = val,
                      decoration: InputDecoration
                      (
                        border: OutlineInputBorder(),
                        labelText: "Username",
                        labelStyle: TextStyle(fontSize: 15.0),
                        hintText: "Must be atleast 3 characters",
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector
              (
                onTap: submit,
                child: Container
                (
                  decoration: BoxDecoration
                  (
                    color:  Colors.blue,
                    borderRadius: BorderRadius.circular(7.0), 
                  ),
                  child: Text
                  (
                    "Submit",style: TextStyle
                    (
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              )
            ],),
          )
        ],
      )

    );
  }
  
}