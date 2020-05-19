import 'package:flutter/material.dart';
import 'package:timetracker/common_widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  // not used 'this' keyword because this class hasn't declared any
  // properties, it just invokes the super class constructor
  SignInButton({
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
          // calling the super class constructor
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 15.0),
          ),
          color: color,
          onPressed: onPressed,
        );
}
