

import 'package:flutter/material.dart';

const myDecoration = InputDecoration(

  //hintText: ""... dont enter this,cz it needs to be customized. use .copyWith at the widget itseelf
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.brown,width: 1.0,)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red,width: 2.0,),
        borderRadius: BorderRadius.all(Radius.circular(8.0))
    )

);