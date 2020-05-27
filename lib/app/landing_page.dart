import 'package:flutter/material.dart';
import 'package:timetracker/app/sign_in/sign_in_page.dart';
import 'package:timetracker/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/services/database.dart';
import 'home/jobs_page.dart';

// responds to changes made in the auth state
// by the stream
class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChange,
      builder: (context, snapshot) {
        // if true, it will tell us that we have received the first value on the stream
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            // both _updateUser and onSignIn have one parameter of type FirebaseUser
            // so we can assign the call back like this instead of '() =>'
            return SignInPage.create(context);
          }
          // Jobs page has a parent Provider of Database
          return Provider<Database>(
            create: (_) => FirestoreDatabase(uid: user.uid),
            child: JobsPage(),
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
