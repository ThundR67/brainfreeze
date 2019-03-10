import 'package:flutter/material.dart';
import 'package:brainfreeze/settings/strings.dart';
import 'math_page.dart';
import 'leaderboard_page.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NavigationDrawerState();
  }
}

class NavigationDrawerState extends State<NavigationDrawer> {
  int _selectedIndex = 0;
  List<String> _pageTitles = [StringsSettings.mathPage, StringsSettings.leaderboardPage];

  Widget _getDrawerItemSelected(int position){
    Widget page;
     switch (position) {
       case 0:
         page = MathPage();
         break;
       case 1:
         page = LeaderboardPage();
         break;
       default:
     }
     return page;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this._pageTitles[this._selectedIndex])
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Container(height: 80),
            RaisedButton(
              child: Text(StringsSettings.mathPage),
              onPressed: () {
                setState(() {
                 this._selectedIndex = 0; 
                });
              },
            ),
            RaisedButton(
              child: Text(StringsSettings.leaderboardPage),
              onPressed: () {
                setState(() {
                 this._selectedIndex = 1; 
                });
              },
            )
          ],
        ),
      ),
      body: _getDrawerItemSelected(this._selectedIndex),
    );
  }
  
}