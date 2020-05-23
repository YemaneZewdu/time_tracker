import 'package:flutter/material.dart';
import 'app/landing_page.dart';
import 'services/auth.dart';
import 'package:provider/provider.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // specifying the kind of object we want to provide with <> because
    // provider is a generic class
    return Provider<AuthBase>(
     create: (context)=>Auth(),
      child: MaterialApp(
        title: 'Time Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LandingPage(),
      ),
    );
  }
}

