import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/common_widgets/platform_alert_dialog.dart';
import 'package:timetracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:timetracker/services/auth.dart';
import 'package:timetracker/services/database.dart';

import 'models/job.dart';

class JobsPage extends StatelessWidget {
  // lets the user sign out
  Future<void> _signOut(BuildContext context) async {
    try {
      // old version
      // await FirebaseAuth.instance.signOut();
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
      // this is used to tell the landing page that the user has logged out
      // commented out because when the user signs in, a new event is push to onAuthStateChanged Stream
      // and the streamBuilder will be called
      // onSignout();
    } catch (e) {
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

  Future<void> _createJob(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context);
      await database.createJob(
        Job(name: "Exercise", ratePerHour: 10),
      );
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: "Operation Failed",
        exception: e,
      ).show(context);
    }
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          final children = jobs.map((job) => Text(job.name)).toList();
          return ListView(children: children);
        }
        if (snapshot.hasError) {
          return Center(child: Text('Some error occurred'));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jobs"),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _createJob(context),
      ),
      body: _buildContents(context),
    );
  }
}
