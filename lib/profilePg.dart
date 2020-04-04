import 'package:blogfirestore/auth.dart';
import 'package:blogfirestore/new_blog.dart';
import 'package:blogfirestore/search_blogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePg extends StatelessWidget {
  final Auth authObj = Auth();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[800],
      appBar: AppBar(
        title: Text('Profile',style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.yellowAccent,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.not_interested,color: Colors.black),
              onPressed: () async {
                await authObj.signOut();
              })
        ],
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("New Blog"),
                onPressed: () {
                  print("new--------");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewBlog()) );
                }
              ),
              RaisedButton(
                child: Text("My Blogs"),
                onPressed: ()=>print("My blogs--------"),
              ),
              RaisedButton(
                child: Text("Commented on..."),
                onPressed: ()=>print("Comments--------"),
              ),
              RaisedButton(
                child: Text("Search All"),
                onPressed: () {
                  print("Search--------");
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> SearchBlogs()));
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
