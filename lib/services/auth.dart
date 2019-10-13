// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';


// abstract class BaseAuth{
//   Stream<String> get onAuthStateChanged;
//   Future<String> signInWithEmailAndPassword(
//       String email, String password,
//       );

//   Future<String> createUserWithEmailAndPassword(
//       String email, String password,
//       );

//   Future<String> currentUser();
//   Future<void> signOut();
//   Future<String> signInWithGoogle();

// }

// class Auth implements BaseAuth{

//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   @override
//   Future<String> createUserWithEmailAndPassword(String email, String password) async {

//     FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email,password: password)).user;
//     return user.uid;
//   }

//   @override
//   Future<String> currentUser() async {

//     FirebaseUser user = await _firebaseAuth.currentUser();
//     return user.uid;
//   }

//   @override

//   Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
//         (FirebaseUser user) => user?.uid,
//   );

//   @override
//   Future<String> signInWithEmailAndPassword(String email, String password) async{

//     FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: email,password: password)).user;
//     return user.uid;
//   }

//   @override
//   Future<String> signInWithGoogle() async{
//     final GoogleSignInAccount account = await _googleSignIn.signIn();
//     final GoogleSignInAuthentication _auth = await account.authentication;
//     final AuthCredential credential = GoogleAuthProvider.getCredential(accessToken: _auth.accessToken,
//         idToken: _auth.idToken
//     );
//     FirebaseUser user = (await _firebaseAuth.signInWithCredential(credential)).user;

//     return user.uid;

//   }

//   @override
//   Future<void> signOut() {

//     return FirebaseAuth.instance.signOut();
//   }

// }