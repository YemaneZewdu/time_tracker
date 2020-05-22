import 'package:flutter/material.dart';
import 'package:timetracker/app/sign_in/sign_in_button.dart';
import 'package:timetracker/app/sign_in/social_sign_in_button.dart';
import 'package:timetracker/services/auth.dart';

class SignInPage extends StatelessWidget {

  // custom call back but moved to using AuthStateChanged
  //final Function(User) onSignIn;
  final AuthBase auth;
   SignInPage({@required this.auth});

  // lets the user sign in anonymously
  Future<void> _signInAnonymously() async {
    try {

      await auth.signInAnonymously();
      // old method
     // final authResult = await FirebaseAuth.instance.signInAnonymously();
      // this method uses a dependency injection of auth class
      //User user = await auth.signInAnonymously();
      // this informs the landing page that there is a new user by a callback
      // commented out because when the user signs in, a new event is push to onAuthStateChanged Stream
      // and the streamBuilder will be called
     // onSignIn(user);
    } catch (e){
      print("Sign In Anonymously Error! " + e.toString());
    }
  }

  Future<void> _signInWithGoogle() async{
    try{
      await auth.signInWithGoogle();
    }
    catch(e){
      print("Sign In With Google Error! " + e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2.0,
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Sign in',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 48.0),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign in with Google',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: _signInWithGoogle,
          ),
          SizedBox(height: 8.0),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: () {},
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Sign in with email',
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: () {},
          ),
          SizedBox(height: 8.0),
          Text(
            'or',
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Go anonymous',
            textColor: Colors.black,
            color: Colors.lime[300],
            onPressed: _signInAnonymously,
          ),
        ],
      ),
    );
  }
}
