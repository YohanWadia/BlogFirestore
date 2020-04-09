import 'dart:async';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class myBadgeWidget extends StatefulWidget {
  FirebaseUser user;
  myBadgeWidget(this.user);

  @override
  _myBadgeWidgetState createState() => _myBadgeWidgetState();
}

class _myBadgeWidgetState extends State<myBadgeWidget> {
  int counter=5;
  bool showKaru= true;

  List<dynamic> theList;


  @override
  Widget build(BuildContext context) {


    theList= Provider.of<List<dynamic>>(context) ?? [];//so if there is nothng we wont get error
    theList.forEach((eachItem){print("....$eachItem");});//but there may be nulls where doc.update's feild doesnt exist
    print("List length: ${theList.length}");
    theList.removeWhere((value) => value == 'x');
    print("List length: ${theList.length}");
    setState(() {
      counter = theList.length;
      if(counter==0){showKaru=false;}
      else{showKaru=true;}
    });


    return Badge(
      badgeContent:  Text('$counter'),position: BadgePosition(right: 4,top:0) , animationType: BadgeAnimationType.scale,
      showBadge: showKaru,
      child: IconButton(icon: Icon(Icons.notifications, size: 32, color: Colors.black),
          onPressed: (){
            setState(() {
              //show a list... should be just a quick peak
              //real noti should take them to showAll
              //and when anyone in that list is clicked, that blogs ref in the users Postcollections doc's update should be reset to 'x'
              //this will automatically make the notification counter in the badge fall down
            });
          }),
    );
  }//.......build ends





}
