import 'package:blogfirestore/auth.dart';
import 'package:blogfirestore/authenticationpg.dart';
import 'package:blogfirestore/profilePg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(//...will use this at 22222222
      value: Auth().AuthChangeStreamz,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StartPage(),
      ),
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  _MyStartPageState createState() => _MyStartPageState();
}

class _MyStartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    //22222222
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    print("StartPage():  $user");

    // return either the Profile or SIgnUp/Register
    if (user != null) {
      return ProfilePg();
    } else {
      return AuthenticationPg();
    }
  }





}
