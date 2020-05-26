import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/app/sign_in/validators.dart';
import 'package:timetracker/common_widgets/form_submit_button.dart';
import 'package:timetracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:timetracker/services/auth.dart';
import 'package:timetracker/app/sign_in/email_sign_in_model.dart';

// used for customizing the text in the sign in button
//enum EmailSignInFormType { signIn, register }

// this class was an old model before moving to using BLoC
// EmailAndPasswordValidators is a mixin to this class
// this class is responsible for building the layout, handling focus and text input
// showing errors and navigating back on success,
// updates the model and signs in or registers the user using Auth,
// holds all the state the form needs, the verification logic, and the computed variables
class EmailSignInFormStateful extends StatefulWidget with EmailAndPasswordValidators {
  @override
  _EmailSignInFormStatefulState createState() => _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // controllers for the 'Next' and 'Done' buttons on the keyboard
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;

  String get _password => _passwordController.text;

  // assigning a default value
  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  // this variable is used for solving the onError in the text fields
  bool _submitted = false;

  // this is used for not letting the user submit a form multiple times
  // before the already submitted form has not been processed
  // favorable for slow network
  bool _isLoading = false;

  // called when widgets are removed from the widget tree
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // this method gets the email and password from the form and signs in the user
  // or creates an account
 Future<void> _submit() async {
    setState(() {
      // once set to true, we can check if there are errors on the text fields
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      // if successful, close the screen
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    }
    // this code is accessed both when the form was successful or unsuccessful
     finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // changes the form types
  void _toggleFormType() {
    setState(() {
      // setting it to false to not show the error text when the user
      // toggles the form from sign in to create an account form
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  // changes the input focus to the password text field
  void _emailEditingComplete() {
    // checking if there is an error on the email text field
    // so that it won't change the focus mode if there is one
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  // updates the state when a character is inputted on the text fields
  // so that the sign in button will be active
  _updateState() {
    setState(() {});
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Register here'
        : 'Log in here';
    // only allowing active submit button when both fields have value and
    // when not in loading state
    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;

    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnabled ? _submit : null,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text(secondaryText),
        // users won't be able to toggle the form in a loading state
        onPressed: !_isLoading ? _toggleFormType : null,
      )
    ];
  }

  TextField _buildEmailTextField() {
    // if the form is submitted and if the field has an error
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: "Email",
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
        // disabling the field after submission and the result is still loading
        enabled: _isLoading == false,
      ),
      // disables text suggestion
      autocorrect: false,
      // displays the @ and . characters
      keyboardType: TextInputType.emailAddress,
      // displays 'next' button instead of the default 'done'
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onEditingComplete: _emailEditingComplete,
      onChanged: (email) => _updateState(),
    );
  }

  TextField _buildPasswordTextField() {
    // if the form is submitted and if the field has an error
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        // disabling the field after submission and the result is still loading
        enabled: _isLoading == false,
      ),
      obscureText: true,
      // displays 'done' button
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onEditingComplete: _submit,
      onChanged: (email) => _updateState(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
