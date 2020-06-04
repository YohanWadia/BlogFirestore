import 'package:blogfirestore/noti.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotiList extends StatefulWidget {
  List<dynamic> items= List<String>();
  NotiList(this.items){
    items.forEach((x) => print("STFUL------ ${x.toString()}"));
  }

  @override
  _NotiListState createState() => _NotiListState();
}

class _NotiListState extends State<NotiList> {
  //List<dynamic> items = List<String>.generate(20, (i) => "Item ${i + 1} A B C D E... X Y Z");
  String whatHappened;
  FirebaseUser user;


  @override
  Widget build(BuildContext context) {
    print("BUILD()=============");
    user = Provider.of<FirebaseUser>(context);
    widget.items.forEach((x) => print("000000 ${x.toString()}"));

    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final noti item = widget.items[index];
          print("ListView>>> ${item.str}");

          return Dismissible(
            key: Key(item.docId),
            onDismissed: (direction) {//this only executes when the swiped action is confirmed
              print("got direction ... $direction");
              if(whatHappened=="DELETED"){
                DocumentReference docRef = Firestore.instance.document('FlutterBlog/Users/${user.uid}/Posts/PostsCollection/${item.docId}');
                docRef.updateData({'update': 'x'});
              }
              setState(() {
                widget.items.removeAt(index);
              });

              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text("${item.str} was $whatHappened")));
            },






            confirmDismiss: (DismissDirection dismissDirection) async {
              switch(dismissDirection) {
                case DismissDirection.endToStart:
                  whatHappened = 'ARCHIVED';
                  return await _showConfirmationDialog(context, 'Archive') == true;
                case DismissDirection.startToEnd:
                  whatHappened = 'DELETED';
                  return await _showConfirmationDialog(context, 'Delete') == true;
                case DismissDirection.horizontal:
                case DismissDirection.vertical:
                case DismissDirection.up:
                case DismissDirection.down:
                  assert(false);
              }
              return false;
            },



            background: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              color: Colors.red,
              alignment: Alignment.centerLeft,
              child: Icon(Icons.cancel),
            ),
            secondaryBackground: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              color: Colors.green,
              alignment: Alignment.centerRight,
              child: Icon(Icons.check,size: 18.0,),
            ),


            //designing of listTile
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.blue), bottom: BorderSide(color: Colors.blue),
                ),
                color: Colors.lightBlue[50],
              ),
              child: ListTile(
                  title: Text('${item.str}', style: TextStyle( fontSize: 18,fontWeight: FontWeight.bold),),
                leading: Icon(Icons.supervised_user_circle,size: 48),
                trailing: (item.isComment)? Icon(Icons.comment,size: 36) : Icon(Icons.insert_emoticon,size: 36),

              ),
            ),
          );
        },
      ),
    );
  }
}

Future<bool> _showConfirmationDialog(BuildContext context, String action) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Do you want to $action this item?'),
        actions: <Widget>[
          FlatButton(
            child: const Text('Yes'),
            onPressed: () {

              Navigator.pop(context, true); // showDialog() returns true
            },
          ),
          FlatButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.pop(context, false); // showDialog() returns false
            },
          ),
        ],
      );
    },
  );
}