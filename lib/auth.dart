


import 'package:firebase_auth/firebase_auth.dart';

class Auth{

  final FirebaseAuth authObj = FirebaseAuth.instance;//make final since this is not changing

 Future registerEmailPwd(String email, String password) async{
    try{
      AuthResult result = await authObj.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      return user;//convert fbUser into USER pojo

    }catch(e){
      print("SignUP... ${e.toString()}");
      return null;
    }
  }


  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await authObj.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      return user;
    } catch (e) {
      print("SignIN... ${e.toString()}");
      return null;
    }
  }

  Stream<FirebaseUser> get AuthChangeStreamz{//this will get you a user directly
    return authObj.onAuthStateChanged;
  }

  Future signOut()async{
    try {
      return authObj.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }




}