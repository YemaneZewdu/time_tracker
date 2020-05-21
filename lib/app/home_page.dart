import 'package:flutter/material.dart';
import 'package:timetracker/services/auth.dart';

class HomePage extends StatelessWidget {

  // used to notify the landing page that the user has logged out
  final VoidCallback onSignout;
  final AuthBase auth;

   HomePage({@required this.onSignout, @required this.auth });
  // lets the user sign out
  Future<void> _signOut() async {
    try {
      // old version
   // await FirebaseAuth.instance.signOut();
      await auth.signOut();
      // this is used to tell the landing page that the user has logged out
      onSignout();
    } catch (e){
      print("Sign out! " + e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Logout",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: _signOut,
          ),
        ],
      ),
    );
  }
}
