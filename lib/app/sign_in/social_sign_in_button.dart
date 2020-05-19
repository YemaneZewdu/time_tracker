import 'package:flutter/material.dart';
import 'package:timetracker/common_widgets/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    @required String assetName,
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(assetName != null),
        assert(text != null),
        // assert will check and stop execution if the boolean condition is false in debug mode
        super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(assetName),
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: 15.0),
              ),
              Opacity(
                opacity: 0.0,
                child: Image.asset(
                  assetName,
                ),
              ),
            ],
          ),
          color: color,
          onPressed: onPressed,
        );
}
