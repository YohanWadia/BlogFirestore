import 'package:blogfirestore/auth.dart';
import 'package:blogfirestore/decor_common.dart';
import 'package:blogfirestore/spinner_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthenticationPg extends StatefulWidget {
  @override
  _AuthenticationPgState createState() => _AuthenticationPgState();
}

class _AuthenticationPgState extends State<AuthenticationPg> {
  int whatTodo = 0; //0=nothing,1=Reg,2=SignIn

  Auth authObj = Auth();
  String email = "", password = "", error = "***";
  final formKey = GlobalKey<FormState>();
  bool needLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Blog"),
      ),
      body:
      needLoading? LoadSpinnerView() :
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  print("CLICKED");
                },
                child: Image.asset("images/blog.png")),
            (whatTodo == 0)
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text("Register"),
                      color: Colors.lightGreen,
                      splashColor: Colors.green[800],
                      //elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          //side: BorderSide(color: Colors.green[800])
                      ),
                      onPressed: () {
                        setState(() {
                          whatTodo = 1;
                        });
                      },
                    ),
                    SizedBox(width:15.0),
                    RaisedButton(
                      child: Text("SignIn"),
                      color: Colors.lightGreen,
                      splashColor: Colors.green[800],
                      //elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        //side: BorderSide(color: Colors.green[800])
                      ),
                      onPressed: () {
                        setState(() {
                          whatTodo = 2;
                        });
                      },
                    ),
                  ],
                )
                : Container(
                    child: Column(
                    children: <Widget>[
                      makeWidget(),
                      makeLastRow(),
                    ],
                  )
                )
          ],
        ),
      ),
    );
  }

  makeWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 5.0),
            TextFormField(
              decoration: myDecoration.copyWith(hintText: "Enter Email"),
              validator: (val) => val.isEmpty ? "Email is needed" : null,
              onChanged: (val) {
                setState(() => email = val);
              },
            ),
            SizedBox(height: 5.0),
            TextFormField(
              decoration: myDecoration.copyWith(hintText: "password please"),
              validator: (val) => val.length < 6 ? "Minimum 6 char needed" : null,
              obscureText: true,
              onChanged: (val) {
                setState(() => password = val);
              },
            ),
          ],
        ),
      ),
    );
  }

  makeLastRow() {
    if (whatTodo == 1) {
      return Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(4.0),
                    //side: BorderSide(color: Colors.pink[400],width: 2.0)
                ),
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    print(email);
                    print(password);

                    setState(() {
                      needLoading = true;
                    });

                    dynamic result = await authObj.registerEmailPwd(email, password);
                    if (result == null) {
                      setState(() {
                        error = "Failed to Register";
                        needLoading = false;
                        print("From setState means NULL");
                      });
                    }//else.. there will be an Authchange that will be listened by the Stream & will change the screen to home automatically
                    else{
                      final userDocRef = Firestore.instance.document("FlutterBlog/Users/${result.uid}/Details");
                      userDocRef.setData({'email':result.email});
                    }
                  }
                }),
            SizedBox(width: 15.0,),
            RaisedButton(
              child: Text("BACK"),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(4.0),
                      side: BorderSide(color: Colors.pink[400],width: 2.0)
                      ),
              onPressed: () {
                setState(() {
                  whatTodo = 0;
                });
              },
            )
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(error,
            style: TextStyle(
                fontSize: 12.0, fontStyle: FontStyle.italic, color: Colors.red))
      ]);
    } else {
      return Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              color: Colors.lightGreen,
              child: Text("SignIN"),
              onPressed: () async {

                if(formKey.currentState.validate()){
                  print(email); print(password);

                  setState(() {
                    needLoading=true;
                  });

                  dynamic result = await authObj.signInWithEmailAndPassword(email, password);
                  if(result==null){
                    setState(() {
                      error="SIGN IN failed!";
                      needLoading=false;
                      print("From setState means NULL");
                    });
                  }//else.. there will be an Authchange that will be listened by the Stream & will change the screen to home automatically
                }

              },
            ),
            SizedBox(width: 15.0,),
            RaisedButton(
              child: Text("Back"),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.lightGreen,width: 2.0)
              ),
              onPressed: () {
                setState(() {
                  whatTodo = 0;
                });
              },
            )
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(error,
            style: TextStyle(
                fontSize: 12.0, fontStyle: FontStyle.italic, color: Colors.red))
      ]);
    }
  }
}
