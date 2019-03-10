//Some Basic Views
import 'package:flutter/material.dart';

AppBar getBasicAppBar(String title, List<Widget> actions) {
  return AppBar(title: Text(title), actions: actions);
}

Text getBasicHeading(String text) {
  return Text(text,
      style: TextStyle(
          fontStyle: FontStyle.normal, fontFamily: "Roboto", fontSize: 24.0));
}

Drawer getBasicDrawer() {
  return Drawer(
    child: Column(
      children: <Widget>[Text("Hey Man")],
    ),
  );
}
