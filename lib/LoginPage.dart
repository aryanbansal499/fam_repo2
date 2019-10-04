
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'validation.dart';
import 'provider.dart';
import 'DialogBox.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pages/CreateAccount.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {

  DialogBox dialogBox = new DialogBox();
  final formKey = GlobalKey<FormState>();
  GoogleSignIn googleSignIn = GoogleSignIn();
  String _email, _password;
  FormType _formType = FormType.login;
  final userRef = Firestore.instance.collection('users');
  final DateTime timeStamp = DateTime.now();


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

   createUserinFireStore() async
  {
    // 1) check if user already exists in the database collection (based on id)
    final GoogleSignInAccount user = googleSignIn.currentUser;
    final DocumentSnapshot doc = await userRef.document(user.id).get();
    // 2) if the user doesnt exist then take them to the create account page.
    if(!doc.exists)
    {
      final username = Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccount()));
    
    //3) get username from create account , use it to make a new user in the database.

    userRef.document(user.id).setData(
      {
        "id": user.id,
        "username": username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "bio": "",
        "timestamp" : timeStamp

      });
    } 
  }
  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        if (_formType == FormType.login) {
        
          dialogBox.imformation(context, "Registered","You have successfully Signed In");
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
          child: Text('Login'),
          color: Colors.brown,
          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40.0)),
          onPressed: submit,
        ),
        
        RaisedButton(
          child: Text('Register Account'),
          color: Colors.brown,
          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40.0)),
          onPressed: () {
            switchFormState('register');
          },
        ),
        Divider(
          height: 20.0,
        ),
        GoogleSignInButton(
          darkMode: false,
          borderRadius: 40,
          onPressed: () async {
            try {
              final _auth = Provider.of(context).auth;
              final id = await _auth.signInWithGoogle();
              createUserinFireStore();
              print('signed in with google $id');
            } catch (e) {
              print(e);
            }
          },
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