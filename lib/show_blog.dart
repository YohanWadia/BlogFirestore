import 'package:blogfirestore/Comment.dart';
import 'package:blogfirestore/blog.dart';
import 'package:blogfirestore/my_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowBlog extends StatefulWidget {

  @override
  _ShowBlogState createState() => _ShowBlogState();
}

class _ShowBlogState extends State<ShowBlog> {
  Blog b;
  List<Comment> commentList = new List();
  FirebaseUser user;
  String strUid;
  String myReaction, myReaction2save;
  String ifUpdtExisted;
  List<int> miniLike=[];//only workaround cause the pojo doesnt hava these values
  List<bool> doneMiniLike=[];//only workaround cause the pojo doesnt hava these values


  var _tapPosition;
  dynamic forLbtn = Icon(Icons.thumb_up);//bcz if we use var type... the 1st time you save the Icon to it...
  // the next time it wont accpet an Img... and even after casting it never got accepted by the FlatButtons Icon property

  void _showCustomMenu() {
    print("onTap..");
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    showMenu(context: context, //initialValue: 1,
        items: <PopupMenuEntry<String>>[myPopUpMenu()],
        position: RelativeRect.fromRect(
                _tapPosition & Size(0,0), // smaller rect, the touch area
                Offset(0,60) & overlay.size   // Bigger rect, the entire screen
        )
    )                         // This is how you handle user selection
    .then<void>((String delta) {// delta would be null if user taps on outside the popup menu(causing it to close without making selection)
      if (delta == null){ return;}
      else {
        setState(() {
          print(delta);
          forLbtn = Image.asset('images/$delta.jpg',width: 30);
          myReaction2save = delta;
        });
      }
    });
    // Another option: final delta = await showMenu(...);
    // Then process `delta` however you want. Remember to make the surrounding function `async`, that is:
    //void _showCustomMenu() async { ... }
  }

  void _storePosition(TapDownDetails details) {
    print("onTapDown..");
    _tapPosition = details.globalPosition;
  }


  void getFromFirebase() async{
    print("myInit() starts =============");

    final CollectionReference commentColRef = Firestore.instance.collection('FlutterBlog/Comments/${b.id}');//-M2PXOYsignsPkBxe2ll');//${b.id}');
    QuerySnapshot querySnapshot = await commentColRef.getDocuments();
    print("SNAP:done");

    if(querySnapshot==null){return;}//dont go ahead without any data, means no comments till now
    // wont be any further errors as the list will be null & wont render in the widget tree

    querySnapshot.documents.forEach((eachDoc){
      var valu = eachDoc.data;
      print(valu);
      commentList.add(Comment( valu['email'],valu['text']));
    });



    //Now check all the Pojos if they were added, by looping through PojoList
    commentList.forEach((obj){
      print('Object: ${obj.txt} ... ${obj.email}');
    });

    setState(() {//you have to call a setstate() cz by the time the data is loaded into the list, build has finished the listView & its blank!
      commentList;
    });
    //==============now reaction


    print("myInit() ends xxxxxxxxxxx");
  }

  final myController = TextEditingController();

    void comment2Firebase(String str, String e) async{
      print("comment2Firebase========");
      //to comment node
      final CollectionReference commentColRef = Firestore.instance.collection('FlutterBlog/Comments/${b.id}');//-M2PXOYsignsPkBxe2ll');//${b.id}');
      var autoId = await commentColRef.add( {'text': str, 'email': e});
      String id = autoId.documentID;
      //to my node
      final DocumentReference myDocRef = Firestore.instance.document('FlutterBlog/Users/$strUid/Posts/PostsCollection/${b.id}');
      await myDocRef.setData({'text' : b.txt, 'update': ifUpdtExisted, 'reaction': myReaction });

      //send notis to everyone in the blog's notiList
      bool present=false;
      final DocumentReference blogDocRef = Firestore.instance.document('FlutterBlog/Blogs/BlogCollection/${b.id}');
      QuerySnapshot snapshot = await blogDocRef.collection('forNotifications').getDocuments();
      snapshot.documents.forEach((element) {
        String hisUid = element.documentID;print("Got docId/uid: $hisUid");
        final DocumentReference userDocRef = Firestore.instance.document('FlutterBlog/Users/$hisUid/Posts/PostsCollection/${b.id}');
        userDocRef.get().then((docSnap){
          if(hisUid==user.uid){present=true;}//if hes already in the list...dont again add him.. see 22222
          userDocRef.updateData({'update':"${user.email} just commented to a post"});  print("finished with $hisUid");
        });
      });

      //add to noti list ... 222222
      if(!present){ blogDocRef.collection('forNotifications').document(user.uid).setData({ });}

      print("comment2Firebasexxxxxxxx");
  }

  void saveReaction2Firebase() async{
      //save to profile
      if(myReaction2save==myReaction){return;}//no need to do anything
      else if(myReaction2save!=null){
        final DocumentReference reactionDocRef = Firestore.instance.document('FlutterBlog/Users/$strUid/Posts/PostsCollection/${b.id}');
          reactionDocRef.setData({'text': b.txt, 'myReaction': myReaction2save, 'update': ifUpdtExisted});
          }
    //only if dint exist +1 to reactions in Blogs
      print('($myReaction == $myReaction2save) ??' );
      if(myReaction==null && myReaction2save!=null){
        //add to views
        final DocumentReference blogDocRef = Firestore.instance.document('FlutterBlog/Blogs/BlogCollection/${b.id}');
        b.reactions++;
        blogDocRef.updateData({'reactions': b.reactions});//since we are going all the way till the field in the ref no update or no json obj req.

        //send notis to everyone in the blog's notiList
        bool present=false;
        QuerySnapshot snapshot = await blogDocRef.collection('forNotifications').getDocuments();
        snapshot.documents.forEach((element) {
          String hisUid = element.documentID;print("Got docId/uid: $hisUid");
          final DocumentReference userDocRef = Firestore.instance.document('FlutterBlog/Users/$hisUid/Posts/PostsCollection/${b.id}');
              userDocRef.get().then((docSnap){
                  if(hisUid==user.uid){present=true;}//if hes already in the list...dont again add him.. see 22222
                  userDocRef.updateData({'update':"${user.email} just reacted to a post"});  print("finished with $hisUid");
              });
        });

        //add to noti list ... 222222
        if(!present){ blogDocRef.collection('forNotifications').document(user.uid).setData({ });}

      }
  }

  void getReactionFromMyNode()async{
    final DocumentReference reactionDocRef = Firestore.instance.document('FlutterBlog/Users/$strUid/Posts/PostsCollection/${b.id}');//-M2PXOYsignsPkBxe2ll');//${b.id}');
    DocumentSnapshot snapshot = await reactionDocRef.get();
    print("SNAP of myReaction: ${snapshot.data}");

    bool test4Update = snapshot?.data?.containsKey("update") ?? false;
    if(test4Update){ifUpdtExisted = snapshot.data['update'];}//so if it did exist we got its value.. and it can never be null it'll be 'x'

    print("RND-- ${snapshot?.data?.containsKey("myReaction")}");//if it contains the key it will be true... but it could contain the key and be null!!
    bool test4Reaction = snapshot?.data?.containsKey("myReaction") ?? false;

    if(!test4Reaction) {print("ORRY not contained");return;}//dont go ahead without any data, means no reactions till now & wont setState.. and will load the original forLbtn from initialization
    myReaction=snapshot.data['myReaction'];
    if(myReaction==null){print("Contained but null");return;}//dont go ahead since its null, means no reactions till now & wont setState.. and will load the original forLbtn from initialization

    setState(() {
      forLbtn = Image.asset('images/$myReaction.jpg',width: 30);
    });
  }


  @override
  void initState() {
    miniLike = List<int>.generate(12, (i) => 0);//just preparing a list of 12 integers of val=0.. for minilikes per comment
    doneMiniLike = List<bool>.generate(12, (i)=>false);
  }

  @override
  Widget build(BuildContext context) {
      if(b==null) {//since receiving the parameters can only be called in build & not init() we will wait for it. But if you dont check for null
        Map args = ModalRoute.of(context).settings.arguments as Map;// it will keep running again & again, cause build() will keep filling the list via getFrirebase
        b= args['blog'];
        strUid= args['Uid'];
        print("Just got B in build()...${b.id}... and UID: $strUid");//.. and the getFirebase will keep setting the state via setState() for the list... that means build()
        getFromFirebase();//will have to be recalled to refresh the widget tree with the new list's data... and this will become an endless loop
        getReactionFromMyNode();
      }

      user = Provider.of<FirebaseUser>(context);//this too cant be called outside build


      void showMyBottomSheet() {
        showModalBottomSheet<dynamic>(//dynamic dint help to keep the height limited
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
            isScrollControlled: true,
            context: context,
            builder: (context){
          return Column(
            //mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(//this guy only has a bottom line as div
                height: 20.0,
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0)),
                ),
              ),

              Expanded(//EXpanded ...so it occupies all the space between the top and bottm widgets
                child: ListView.builder(
                    itemCount: commentList.length,
                    itemBuilder: (context,index){
                      print("building starts");
                      return CommentTile(commentList[index],index);
                    }
                ),
              ),

              Padding(//padding is madatory if you want the textfield to pop up over the keyboard
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),//this line does the trick
                child: Container(//since we still need some kinda margin & padding was already used in the above line
                  margin: EdgeInsets.fromLTRB(20,20,20, 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2.0),
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(40.0)
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(//textfeilds throw errors in single row cause the row cant know its width, hence expanded first & then textfeild
                          child: TextField(
                            maxLines: null,//this allows the textfeild to grow dynamically as it is required
                            keyboardType: TextInputType.multiline,
                            controller: myController,
                            decoration: InputDecoration(
                                hintText: "Enter Comment...",
                                contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 25),//internal padding of the textfeild
                                border: InputBorder.none,//so no line comes under the textfeild
                                focusedBorder: InputBorder.none,//so no line comes under the textfeild
                            ),
                          ),
                      ),
                      IconButton(icon: Icon(Icons.send), iconSize: 28.0, color: Colors.lightBlue,
                        onPressed: ()async{
                          print("send=====");
                         // FirebaseUser user = Provider.of<FirebaseUser>(context);
                          await comment2Firebase(myController.text,user.email);
                          commentList.clear();
                          getFromFirebase();
                          Navigator.pop(context);
                          print("sendxxxxx");
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        });
      }





    return Scaffold(
      appBar: AppBar(
        title: Text("The Blog") ,
      ),
      body:
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Icon(
                          Icons.account_box,
                          color: Colors.blue[300],
                          size: 72.0,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(b.email,
                          style: TextStyle(color: Colors.blue[800], fontSize: 24.0),
                        ),
                        Text("online",
                          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 14.0),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 20.0),
                Text(b.txt, textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: GestureDetector(
                          onLongPress: _showCustomMenu,
                          onTapDown: _storePosition,
                          child: OutlineButton.icon(
                            icon: forLbtn,
                            label: Text(""),
                            onPressed: (){
                              setState(() {
                                print("LIKED!");
                                forLbtn = Image.asset('images/thumb.jpg',width: 30);
                                myReaction2save="thumb";
                              });
                            }
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: OutlineButton.icon(
                          icon: Icon(Icons.chat),
                          label: Text(""),
                          onPressed: (){showMyBottomSheet();},
                        ),
                      ),
                    ),

                  ],
                ),
                Expanded(//if you dont wrap in EXpanded there will be scroll problem & overflow eror
                  child: ListView.builder(
                      itemCount: commentList.length,
                      itemBuilder: (context,index){
                        print("building starts");
                        return CommentTile(commentList[index],index);
                      }
                  ),
                )

              ],
            ),
          ),

    );
  }//build method

  @override
  void dispose() {
      print("DISPOSE....");
    myController.dispose();
    saveReaction2Firebase();
    super.dispose();
  }





    Widget CommentTile(Comment c, int indx) {
    print("tile.... ${c.txt}.... $indx");
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
         Icon(
          Icons.account_box,
          color: Colors.indigoAccent[200],
          size: 36.0,
         ),
          Expanded(
            child: Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 8.0),
                    decoration: BoxDecoration(color: Colors.grey[200],borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(c.email,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold)),
                        Text(c.txt,style: TextStyle(fontSize: 16.0),softWrap: true,),
                        SizedBox(height: 10.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            (miniLike[indx]==0 || doneMiniLike[indx]==false)?
                              GestureDetector(
                                  child: Text("Like",style: TextStyle(fontSize: 18,color: Colors.grey[600],fontWeight: FontWeight.bold)),
                              onTap: (){
                                    miniLike[indx]++;
                                    setState(() {
                                      doneMiniLike[indx]= !(doneMiniLike[indx]);
                                      miniLike[indx];
                                    });
                              },
                              )
                            :   // .... or....
                            GestureDetector(
                                child: Icon(Icons.thumb_up,color: Colors.blue),
                              onTap: (){
                                miniLike[indx]--;
                                setState(() {
                                  doneMiniLike[indx]=!(doneMiniLike[indx]);
                                  miniLike[indx];
                                });
                              },
                            ),

                            SizedBox(width: 15.0),
                            Text("Reply",style: TextStyle(fontSize: 18,color: Colors.grey[600],fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    )
                ),

                  (miniLike[indx]==0)? Container()//means return an empty container.. or you could use Visibility widget
                      :  // .... or....
                  Positioned(
                      left: 15, bottom: 0,
                      child: AnimateMiniLike(miniLike[indx])),


                ],
            ),
          ),
          ),
        ],
      ),

    );
  }






  
  /* // the propblem with this approach is that its a Dialog... so when it appears everything else on the screen gets an overlay
      // and they go into the background... so thats why we need something like a popup list menu.
  void showEmojis() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0), side: BorderSide(width: 4.0,color: Colors.white)
            ), //this right here

              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {print("thumb");},
                      child: Image.asset('images/thumb.jpg',width: 40,),
                    ),
                    GestureDetector(
                      onTap: () {print("heart");},
                      child: Image.asset('images/heart.jpg',width: 40),
                    ),
                    GestureDetector(
                      onTap: () {print("haha");},
                      child: Image.asset('images/haha.jpg',width: 40),
                    ),
                    GestureDetector(
                      onTap: () {print("wow");},
                      child: Image.asset('images/wow.jpg',width: 40),
                    ),
                    GestureDetector(
                      onTap: () {print("cry");},
                      child: Image.asset('images/cry.jpg',width: 40),
                    ),
                    GestureDetector(
                      onTap: () {print("angry");},
                      child: Image.asset('images/angry.jpg',width: 40),
                    ),
                  ],
                ),
              ),

          );
        });
  }*/

}

//==========================popupItemMenu class
class myPopUpMenu extends PopupMenuEntry<String> {
  @override
  double height = 30;
  // height doesn't matter, as long as we are not giving
  // initialValue to showMenu().

  @override
  bool represents(String n) => true;

  @override
  myPopUpMenuState createState() => myPopUpMenuState();
}

class myPopUpMenuState extends State<myPopUpMenu> {

  void passClicked( String str) {
    Navigator.pop<String>(context, str);//this str becomes delta in the gesture detection
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: IconButton(icon:Image.asset('images/thumb.jpg',width: 35), onPressed:(){ passClicked("thumb");})),
        Expanded(child: IconButton(icon:Image.asset('images/heart.jpg',width: 35), onPressed:(){ passClicked("heart");})),
        Expanded(child: IconButton(icon:Image.asset('images/wow.jpg',width: 35), onPressed:(){ passClicked("wow");})),
        Expanded(child: IconButton(icon:Image.asset('images/cry.jpg',width: 35), onPressed:(){ passClicked("cry");})),
        Expanded(child: IconButton(icon:Image.asset('images/haha.jpg',width: 35), onPressed:(){ passClicked("haha");})),
        Expanded(child: IconButton(icon:Image.asset('images/angry.jpg',width: 35), onPressed:(){ passClicked("angry");})),
    ]
    );
  }
}
