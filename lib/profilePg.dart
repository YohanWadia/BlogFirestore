
import 'package:blogfirestore/auth.dart';
import 'package:blogfirestore/new_blog.dart';
import 'package:blogfirestore/noti.dart';
import 'package:blogfirestore/noti_list.dart';
import 'package:blogfirestore/search_blogs.dart';
import 'package:blogfirestore/settings_pg.dart';
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
  List<noti> forNotiList=[];//for notiList pg where provider wont work

  Stream<List<dynamic>> get pojoStuff{//this doesnt fire everytime there is an update or change. it only organises it the first time.. after that,
    print("over here.......000000000000");// it's makeNotiListfromSnapshot() is the only one to keep firing.
    myRef = Firestore.instance.collection('FlutterBlog/Users/${user.uid}/Posts/PostsCollection');
    forNotiList.clear();
    return myRef.snapshots().map(makeNotiListfromSnapshot);
  }

  List<dynamic> makeNotiListfromSnapshot(QuerySnapshot snapshot) {
    print("over here.......111111111111");
    forNotiList.clear();//otherwise everytime it fires .. it keeps appending new records
    return snapshot.documents.map((eachDoc) {
        String str = eachDoc.data['update'];
        print("...at ${eachDoc.documentID} ... $str ");
        if(str!=null && str!='x'){//while you are returning the dynamic list as a stream... also build a list for the NotiPg that
          bool bul = str.contains("commented");//needs the docId and if it was a comment
          forNotiList.add(noti(eachDoc.documentID,str, bul));
        }
        return str;
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
              //color: Colors.green[200],
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
                  print('NOTIlist click...');
                  fabKey.currentState.close();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NotiList(forNotiList)) );
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
                IconButton(icon: Icon(Icons.settings), iconSize: 40, onPressed: () {
                  print('search');
                  fabKey.currentState.close();
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> MySettingsPage()));
                }),
              ]
          )
      ),
    );
  }
}
