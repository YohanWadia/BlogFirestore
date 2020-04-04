import 'package:blogfirestore/show_blog.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:blogfirestore/blog.dart';
import 'package:provider/provider.dart';

class SearchBlogs extends StatefulWidget {
  @override
  _SearchBlogsState createState() => _SearchBlogsState();
}

class _SearchBlogsState extends State<SearchBlogs> {
  List<Blog> blogsList = new List();

  void myInit() async{
    print("myInit() starts =============");

    final blogRef = FirebaseDatabase.instance.reference().child('FlutterBlog/Blogs');
    DataSnapshot snapshot = await blogRef.once();
    print(snapshot.value);

    Map<dynamic,dynamic> mapSnap = snapshot.value;
    mapSnap.forEach((k,v){
      print('$k : $v');
      blogsList.add(Blog(k, v['text'], v['reactions'], v['email']));
    });

    //Now check all the Pojos if they were added, by looping through PojoList
    blogsList.forEach((obj){
      print('Object: ${obj.txt} ... ${obj.reactions}');
    });

    setState(() {//you have to call a setstate() cz by the time the data is loaded into the list, build has finished the listView & its blank!
      blogsList;
    });

  print("myInit() ends xxxxxxxxxxx");
  }


  @override
  void initState()  {//this is the proof, initState() is synchronous and doesnt wait for myINIT to complete, even with Future..
                      // Cz u cant use await. cz you cant make this method async
    super.initState();
    print("initState() method starts ============");
    //myInit();
    Future.delayed(Duration.zero,() {//even if you make this async await... it still is no diff from single line myInit()
      myInit();
    });
    print("initState() method ends xxxxxxxxxx");
  }


  FirebaseUser user;

  @override
  Widget build(BuildContext context) {

    user = Provider.of<FirebaseUser>(context);

    print("==================== ${blogsList.length}");


    return Scaffold(
      appBar: AppBar(
        title:Text("Search Blogs")
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
            style: TextStyle(fontSize: 25.0),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                prefixIcon: Icon(Icons.search),
                hintText: "Ask for a Blog...",
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 6.0),
                    borderRadius: BorderRadius.circular(25.0) ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red[300], width: 32.0),
                    borderRadius: BorderRadius.circular(25.0))
                ),
            ),
            SizedBox(
              height: 16.0,
            ),

            Expanded(//if you dont wrap in EXpanded there will be scroll problem & overflow eror
              child: ListView.builder(
                  //shrinkWrap: true,
                  //scrollDirection: Axis.vertical,
                  itemCount: blogsList.length,
                  itemBuilder: (context,index){
                    print("building starts");
                    return BlogTile(blogsList[index],index);
                  }
              ),
            )

          ],
        ),
      )

    );

  }


  Widget BlogTile(Blog b, indexx) {
    print("hehehheehhee ${b.txt}");
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 10,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.account_box,
              color: Colors.purple,
              size: 48.0,
            ),
            //contentPadding: EdgeInsets.fromLTRB(5, 10, 5, 5),
            title: Text(b.txt),
            subtitle: Text("Views ${b.reactions}"),

            onTap: () {
              print("clicked...($indexx)- ${b.txt}...  "); //you can add a click event to get that objects data
              Navigator.push (context, MaterialPageRoute(builder: (context)=> ShowBlog(), settings: RouteSettings(arguments: {'blog':b, 'Uid':user.uid}) ));
            }
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Align(
              child: Text(b.email,style: TextStyle(color: Colors.purple[300],fontStyle: FontStyle.italic),),
              alignment: Alignment.centerRight,
            ),
          )
        ],
      ),

    );
  }


}
