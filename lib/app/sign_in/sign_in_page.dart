import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/app/sign_in/email_sign_in_page.dart';
import 'package:timetracker/app/sign_in/sign_in_manager.dart';
import 'package:timetracker/app/sign_in/sign_in_button.dart';
import 'package:timetracker/app/sign_in/social_sign_in_button.dart';
import 'package:timetracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:timetracker/services/auth.dart';

class SignInPage extends StatelessWidget {
  final SignInManager manager;
  final bool isLoading;

  SignInPage({@required this.manager, @required this.isLoading});

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);

    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          // the _ is just a placeholder
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          // removing it from the widget tree when the screen is closed
          //   dispose: (context, bloc)=>bloc.dispose(),
          // Consumer is like a glue that holds Provider and widget
          // and lets widgets rebuild themselves when a value is changed
          // registers for updates
          child: Consumer<SignInManager>(
            builder: (context, manager, _) => SignInPage(
              manager: manager,
              // .value lets us extract the boolean value
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  // used for showing a circular progress indicator when the sign in
  // buttons are pressed and it is in progress
  //bool _isLoading = false;

  // this handles showing the error messages from sign in with google and anonymously
  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  // let's the user sign in anonymously
  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      // when the button is tapped set _isloading to true
      // setState(() => _isLoading = true); old method
      //final auth = Provider.of<AuthBase>(context, listen: false);
      await manager.signInAnonymously();
    } catch (e) {
      _showSignInError(context, e);
//    } finally {
//      // whether there was an error or not, set it back to false
//      //  setState(() => _isLoading = false); old method
//
//    }
    }
  }

  // let's the user sign in with Google
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      // when the button is tapped set _isloading to true
      //setState(() => _isLoading = true);

      // final auth = Provider.of<AuthBase>(context, listen: false);
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      // if the user canceled the sign in request from the dialog box
      // asking if they want to sign in with Google account,
      // then no error dialog box should be displayed
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
//    } finally {
//      // whether there was an error or not, set it back to false
//      // setState(() => _isLoading = false);
//    }
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // makes the page slide in and out from the bottom on iOS
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final isLoading = Provider.of<ValueNotifier<bool>>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  // used for showing a 'sign in' text or a CircularProgressIndicator
  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Sign in',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: 16.0, right: 16.0, top: 100, left: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 50.0,
              child: _buildHeader(),
            ),
            SizedBox(height: 48.0),
            SocialSignInButton(
              assetName: 'images/google-logo.png',
              text: 'Sign in with Google',
              textColor: Colors.black87,
              color: Colors.white,
              // disable the button if it is in loading state
              onPressed: isLoading ? null : () => _signInWithGoogle(context),
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
              // disable the button if it is in loading state
              onPressed: isLoading ? null : () => _signInWithEmail(context),
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
              // disable the button if it is in loading state
              onPressed: isLoading ? null : () => _signInAnonymously(context),
            ),
          ],
        ),
      ),
    );
  }
}
