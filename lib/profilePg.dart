
import 'package:blogfirestore/auth.dart';
import 'package:blogfirestore/new_blog.dart';
import 'package:blogfirestore/search_blogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'myBadgeWidget.dart';

class ProfilePg extends StatefulWidget {
  @override
  _ProfilePgState createState() => _ProfilePgState();
}

class _ProfilePgState extends State<ProfilePg> {
  final Auth authObj = Auth();
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  FirebaseUser user;
  CollectionReference myRef;

  Stream<List<dynamic>> get pojoStuff{
    myRef = Firestore.instance.collection('FlutterBlog/Users/${user.uid}/Posts/PostsCollection');
    return myRef.snapshots().map(makeNotiListfromSnapshot);
  }

  List<dynamic> makeNotiListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((eachDoc) {
        print("...at ... ${eachDoc.data['update']} ");
        return eachDoc.data['update'];
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    print("Profile pg:  $user");

    return StreamProvider<List<dynamic>>.value(
        value: pojoStuff,
      child: Scaffold(
        backgroundColor: Colors.yellow[800],
        appBar: AppBar(
          title: Text('Profile',style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.yellowAccent,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.not_interested, color: Colors.black),
                onPressed: () async {
                  await authObj.signOut();
                }),
            /*IconButton(
              icon: Icon(Icons.notifications, size: 32, color: Colors.black),
                  onPressed: (){},
            )*/
            Container(
              color: Colors.green[200],
              padding: EdgeInsets.all(2),
              child: myBadgeWidget(user),//separate widget as this needs state & parent widget is stateless
            ),




          ],
        ),
        body: Container(
          decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage('images/bkg.jpg'))
          ),
        ),
          floatingActionButton: FabCircularMenu(
            key: fabKey,
            //ringDiameter: fabKey.currentState.widget.ringDiameter * 0.75,
            fabColor: Colors.yellow,
            fabOpenIcon: Icon(Icons.touch_app),
            fabOpenColor: Color.fromARGB(128, 200, 0, 200),
            ringColor: Color.fromARGB(128, 200, 0, 200),
              children: <Widget>[
                IconButton(icon: Icon(Icons.notifications),iconSize: 40, onPressed: () {
                  print('Home');
                }),
                IconButton(icon: Icon(Icons.fiber_new),iconSize: 40, onPressed: () {
                  print('new');
                  fabKey.currentState.close();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewBlog()) );
                }),
                IconButton(icon: Icon(Icons.search), iconSize: 40, onPressed: () {
                  print('search');
                  fabKey.currentState.close();
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> SearchBlogs()));
                }),
              ]
          )
      ),
    );
  }
}
