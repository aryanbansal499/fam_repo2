import 'package:flutter/material.dart';

import '../services/provider.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {

  DialogBox dialogBox = new DialogBox();
  final formKey = GlobalKey<FormState>();

  String _email, _password;
  FormType _formType = FormType.login;

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
        final auth = MyProvider.of(context).auth;
        if (_formType == FormType.login) {

          String userId = await auth.signInWithEmailAndPassword(
            _email,
            _password,
          );

          print('Signed in $userId');
        } else {
          dialogBox.imformation(context, "Registered","You have successfully Signed Up");
          String userId = await auth.createUserWithEmailAndPassword(
            _email,
            _password,
          );

          print('Registered in $userId');
        }
      } catch (e) {
        dialogBox.imformation(context, "Error ",e.toString());
        print(e);
      }
    }
  }

  void switchFormState(String state) {
    formKey.currentState.reset();

    if (state == 'register') {
      setState(() {
        _formType = FormType.register;
      });
    } else {
      setState(() {
        _formType = FormType.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: DecoratedBox
          (
          position: DecorationPosition.background,
          decoration: BoxDecoration(
            color: Colors.red,
            image: DecorationImage(
                image: AssetImage('images/bg.png'),
                fit: BoxFit.cover),
          ),
          child:Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: buildInputs() + buildButtons(),
              ),
            ),
          ),
        )
    );
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        validator: EmailValidator.validate,
        decoration: InputDecoration(hintText: 'Email',filled: true,fillColor: Colors.black12),
        onSaved: (value) => _email = value,
        cursorColor: Colors.brown,
      ),
      Divider(
        height: 10.0,
      ),
      TextFormField(
        validator: PasswordValidator.validate,
        decoration: InputDecoration(hintText: 'Password',filled: true,fillColor: Colors.black12),
        obscureText: true,
        onSaved: (value) => _password = value,
      ),

    ];

  }

  List<Widget> buildButtons() {
    if (_formType == FormType.login) {
      return [
        Divider(
          height: 20.0,
        ),
        RaisedButton(
          child: Text('Sign In'),
          color: Colors.grey,
          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
          onPressed: submit,
        ),

        RaisedButton(
          child: Text('Sign up'),
          color: Colors.grey,
          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
          onPressed: () {
            switchFormState('register');
          },
        ),
        Divider(
          height: 30.0,
        ),

      ];
    } else {
      return [
        RaisedButton(
          child: Text('Create Account'),
          color: Colors.brown,
          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40.0)),
          onPressed: submit,
        ),
        FlatButton(
          child: Text('Go to Login'),
          color: Colors.brown,
          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40.0)),
          onPressed: () {
            switchFormState('login');
          },
        )
      ];
    }
  }
}


class DialogBox
{
  imformation(BuildContext context, String title, String description)
  {
    return showDialog(
        context: context,
        barrierDismissible: true,

        builder: (BuildContext context)
        {
          return AlertDialog (
            title: Text(title),
            content: SingleChildScrollView
              (
              child: ListBody
                (
                children: <Widget>
                [
                  Text(description)
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),

                onPressed: ()
                {
                  return Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }
}

enum FormType{login, register}

class EmailValidator {
  static String validate(String value)
  {
    return value.isEmpty ? "Email can't be empty " : null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    return value.isEmpty ? "Password can't be empty" : null;
  }
}