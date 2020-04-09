import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blogfirestore/main.dart';

class NewBlog extends StatelessWidget {
  final blogColRef = Firestore.instance.collection('FlutterBlog/Blogs/BlogCollection');//
  CollectionReference userColRef;
  String txt;
  final snackBar = SnackBar(content: Text('Post has been Done!'));

  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    print("from NewBlog:  $user.... ${user.email}");
    userColRef = Firestore.instance.collection('FlutterBlog/Users/${user.uid}/Posts/PostsCollection');// 1st is collection 2nd is Doc 3r is uidCollection

    return Scaffold(
      backgroundColor: Colors.lightBlue[300],
      appBar: AppBar(
        title: Text("New Blog") ,
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[

            Row(
              children: <Widget>[
                Icon(
                  Icons.account_circle,
                  color: Colors.pink[300],
                  size: 48.0,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.only(left:10.0,bottom: 5.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.lightBlueAccent[100], ),
                    child: Text(user.email,
                       style: TextStyle(color: Colors.black, fontSize: 30.0),
                     ),
                  ),
                ),

              ],
            ),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                hintText: "Enter Stuff",
                fillColor: Colors.lightBlueAccent[100],
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlueAccent,width: 2.0,),
                    borderRadius: BorderRadius.all(Radius.circular(6.0))
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue,width: 3.0,),
                    borderRadius: BorderRadius.all(Radius.circular(16.0))
                  ),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                onChanged:(val){
                  txt=val;
                },
              ),
            ),
            Builder(builder: (ctx) => RaisedButton(
                child: Text("POST"),
                color: Colors.blue[500],
                onPressed: (){
                  print("clicked");
                  makeEntry();
                  Scaffold.of(ctx).showSnackBar(snackBar);
                },
              )
            )

          ],
        )

      ),
    ) ;
  }

  void makeEntry() async{
    print(txt);
    var autoId = await blogColRef.add( {'text': txt, 'email': user.email, 'reactions': 0});
    String id = autoId.documentID;
    blogColRef.document(id).collection('forNotifications').document(user.uid).setData({ });
    await userColRef.document(id).setData({'text': txt, 'update' : 'x'});

  }




}//class





