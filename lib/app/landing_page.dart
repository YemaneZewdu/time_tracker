import 'package:flutter/material.dart';
import 'package:timetracker/app/sign_in/sign_in_page.dart';
import 'package:timetracker/services/auth.dart';

import 'home_page.dart';

class LandingPage extends StatelessWidget {
  final AuthBase auth;

  LandingPage({@required this.auth});

  // old version used for state management
//  User _user;
//
//  @override
//  void initState() {
//    super.initState();
//    _checkCurrentUser();
//    // subscribing to the stream
//    widget.auth.onAuthStateChange.listen((user) {
//      // prints user id or null if the user logs out
//      print('user: ${user?.uid}');
//    });
//  }
//
//  Future<void> _checkCurrentUser() async {
//    // check if the user is signed in
//    // also used when the app is run in hot restart while the user is signed in
//    // old version
//    // FirebaseUser user = await FirebaseAuth.instance.currentUser();
//    User user = await widget.auth.currentUser();
//    _updateUser(user);
//  }
//
//  // this is used to update the user state when user signs in or out
//  void _updateUser(User user) {
//    setState(() {
//      _user = user;
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: auth.onAuthStateChange,
      builder: (context, snapshot) {
        // if true, it will tell us that we have received the first value on the stream
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            // both _updateUser and onSignIn have one parameter of type FirebaseUser
            // so we can assign the call back like this instead of '() =>'
            return SignInPage(
              // old version
              //  onSignIn: _updateUser,
              auth: auth,
            );
          }
          return HomePage(
            //old version
            // this will be called when the user signs out and _updateUser
            // is called with a null value because there is no user id
            // onSignout: () => _updateUser(null),
            auth: auth,
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
