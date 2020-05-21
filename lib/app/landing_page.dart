import 'package:flutter/material.dart';
import 'package:timetracker/app/sign_in/sign_in_page.dart';
import 'package:timetracker/services/auth.dart';

import 'home_page.dart';

class LandingPage extends StatefulWidget {
  final AuthBase auth;

  LandingPage({@required this.auth});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User _user;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    // check if the user is signed in
    // also used when the app is run in hot restart while the user is signed in
    // old version
    // FirebaseUser user = await FirebaseAuth.instance.currentUser();
    User user = await widget.auth.currentUser();
    _updateUser(user);
  }

  // this is used to update the user state when user signs in or out
  void _updateUser(User user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      // both _updateUser and onSignIn have one parameter of type FirebaseUser
      // so we can assign the call back like this instead of '() =>'
      return SignInPage(
        onSignIn: _updateUser,
        auth: widget.auth,
      );
    }
    return HomePage(
      // this will be called when the user signs out and _updateUser
      // is called with a null value because there is no user id
      onSignout: () => _updateUser(null),
      auth: widget.auth,
    );
  }
}
