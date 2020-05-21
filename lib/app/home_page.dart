import 'package:flutter/material.dart';
import 'package:timetracker/services/auth.dart';

class HomePage extends StatelessWidget {

  // used to notify the landing page that the user has logged out but moved to using AuthStateChanged
 // final VoidCallback onSignout;
  final AuthBase auth;

   HomePage({@required this.auth });
  // lets the user sign out
  Future<void> _signOut() async {
    try {
      // old version
   // await FirebaseAuth.instance.signOut();
      await auth.signOut();
      // this is used to tell the landing page that the user has logged out
      // commented out because when the user signs in, a new event is push to onAuthStateChanged Stream
      // and the streamBuilder will be called
     // onSignout();
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
