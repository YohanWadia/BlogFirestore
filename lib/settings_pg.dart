import 'package:blogfirestore/profilePg.dart';

import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';


class MySettingsPage extends StatefulWidget {
  @override
  MySettingsPageState createState() => MySettingsPageState();
}

class MySettingsPageState extends State<MySettingsPage> {
  int currentPage = 0;

  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fancy Bottom Navigation"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: _getPage(currentPage),
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(
              iconData: Icons.home,
              title: "Home",
              onclick: () { print("wohohoho");
                final FancyBottomNavigationState fState =
                    bottomNavigationKey.currentState;
                fState.setPage(2);
              }),
          TabData(
              iconData: Icons.search,
              title: "Search",
              onclick: () {
                print("comeON");//beter to use a button on the tab screen than these clicks as they arent reliable
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePg()));
                }
                ),
          TabData(iconData: Icons.shopping_cart, title: "Basket")
        ],
        initialSelection: 1,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 8, 0, 12),
              padding: EdgeInsets.all(8.0),
              color: Colors.red,
                child: Text("STUFF", style: TextStyle(fontSize: 36.0,fontWeight: FontWeight.bold),)
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(Icons.settings,size: 24,color: Colors.red,),
                ),
                Text("Settings", style: TextStyle(fontSize: 24.0),),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Divider(thickness: 2.0,color:Colors.grey),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(Icons.card_travel,size: 24,color: Colors.red,),
                ),
                Text("Extras", style: TextStyle(fontSize: 24.0),),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Divider(thickness: 2.0,color:Colors.grey),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(Icons.account_balance,size: 24,color: Colors.red,),
                ),
                Text("Balance", style: TextStyle(fontSize: 24.0),),
              ],
            ),

          ],
        ),
      ),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Home Page for Settings"),
            RaisedButton(
              child: Text(
                "Change Password",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                //Navigator.of(context).push(                    MaterialPageRoute(builder: (context) => SecondPage()));
              },
            ),
            RaisedButton(
              child: Text(
                "GO TO page 3",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                final FancyBottomNavigationState fState =
                    bottomNavigationKey.currentState;
                fState.setPage(2);
              },
            )
          ],
        );
      case 1:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Search Page"),
            RaisedButton(
              child: Text(
                "Search for a Setting you need to change",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                //Navigator.of(context).push(                    MaterialPageRoute(builder: (context) => SecondPage()));
              },
            )
          ],
        );
      default:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Basket Details page"),
            RaisedButton(
              child: Text(
                "Change your CC info",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {},
            )
          ],
        );
    }
  }
}