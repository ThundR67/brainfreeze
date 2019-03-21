import 'package:flutter/material.dart';
import 'vulcun_client/vulcun_client.dart';
import 'settings/strings.dart';
import 'pages/login_page.dart';
import 'pages/math_page.dart';
import 'pages/navigation_drawer.dart';
import 'pages/signup_page.dart';




void main() async {
  var _defaultHome;

  VulcunClient vulcunClient = VulcunClient(null, null);

  await vulcunClient.retreiveData();

  if (vulcunClient.accessToken == null ||
      vulcunClient.refreshToken == null ||
      vulcunClient.currentUsername == null) {
    //User not logged in, Therfeore redirect them to login page
    _defaultHome = LoginPage();
  } else {
    _defaultHome = NavigationDrawer();
  }

  runApp(new MaterialApp(
    title: StringsSettings.appName,
    home: _defaultHome,
    routes: <String, WidgetBuilder>{
      // Set routes for using the Navigator.
      StringsSettings.navigateRoute: (BuildContext context) =>
          NavigationDrawer(),
      StringsSettings.mathRoute: (BuildContext context) => MathPage(),
      StringsSettings.loginRoute: (BuildContext context) => LoginPage(),
      StringsSettings.signUpRoute: (BuildContext context) => SignUpPage()
    },
  ));
}
