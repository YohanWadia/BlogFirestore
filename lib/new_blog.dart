import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blogfirestore/main.dart';

class NewBlog extends StatelessWidget {
  final blogRef = FirebaseDatabase.instance.reference().child('FlutterBlog/Blogs');
  final userRef = FirebaseDatabase.instance.reference().child('FlutterBlog/Users');
  String txt;
  final snackBar = SnackBar(content: Text('Post has been Done!'));

  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    print("from NewBlog:  $user.... ${user.email}");

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

  void makeEntry(){
    print(txt);
    String newNode = blogRef.push().key;
    //blogRef.child(newNode).set({'text': txt, 'reactions': 0});
    //userRef.child(user.uid+'/Posts/'+newNode).set({'text': txt});
    //if you want to do it simultaneously like in Android or Js
    Map<String, dynamic> mapUpdt = {};
    mapUpdt['FlutterBlog/Blogs/' +  newNode] = {'text': txt, 'reactions': 0};
    mapUpdt['FlutterBlog/Users/' + user.uid +'/Posts/' + newNode] = {'text': txt};

    FirebaseDatabase.instance.reference().update(mapUpdt);
  }




}//class





