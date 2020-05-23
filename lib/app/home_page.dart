import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/common_widgets/platform_alert_dialog.dart';
import 'package:timetracker/services/auth.dart';

class HomePage extends StatelessWidget {


  // lets the user sign out
  Future<void> _signOut(BuildContext context) async {
    try {
      // old version
   // await FirebaseAuth.instance.signOut();
      final auth = Provider.of<AuthBase>(context,listen: false);
      await auth.signOut();
      // this is used to tell the landing page that the user has logged out
      // commented out because when the user signs in, a new event is push to onAuthStateChanged Stream
      // and the streamBuilder will be called
     // onSignout();
    } catch (e){
      print("Sign out! " + e.toString());
    }
  }

  // confirm if the user wants to sign out
  Future<void> _confirmSignOut(BuildContext context) async {
    // getting the return value from the alert dialog
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      defaultActionText: 'Logout',
      cancelActionText: 'Cancel',
    ).show(context);
    // if the return value is true, then sign out the user
    if (didRequestSignOut == true) {
      _signOut(context);
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
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
    );
  }
}
