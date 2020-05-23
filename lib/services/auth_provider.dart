// commented out after moving to using Provider

//import 'package:flutter/material.dart';
//import 'package:timetracker/services/auth.dart';
//
//class AuthProvider extends InheritedWidget {
//  AuthProvider({@required this.auth, @required this.child});
//  final AuthBase auth;
//  final Widget child;
//
//  @override
//  bool updateShouldNotify(InheritedWidget oldWidget) => false;
//
//  // final auth = AuthProvider.of(context);
//  // gives us access to the auth provider
//  static AuthBase of(BuildContext context) {
//    return context.dependOnInheritedWidgetOfExactType<AuthProvider>().auth;
//  }
//}