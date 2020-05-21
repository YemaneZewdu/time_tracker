import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

// generic user class
class User {
  final String uid;

  User({@required this.uid});
}

abstract class AuthBase{

  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<void> signOut();

}

// This class is completely decoupled from Firebase and the project only knows this Auth class
// this class is used to handle the necessary steps for sign in/out
// if we want to remove firebase and use another service or a breaking change occurs,
// then we can just update this class
class Auth implements AuthBase{
  final _firebaseAuth = FirebaseAuth.instance;

  // converts Fireabse user obj to User class obj
  User _userFromFirebase(FirebaseUser user){
    if (user == null){
      return null;
    }
    return User(uid: user.uid);
  }

  @override
  Future<User> currentUser() async {
    final user =  await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

