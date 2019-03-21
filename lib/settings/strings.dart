//All String Data For BrainFreeze
import 'package:flutter/material.dart';

class StringsSettings {


  static final String appName = "BrainFreeze";
  static final Widget noInternet = Text("Connect To Internet");


  static final String mathSubject = "math";

  //Navigation
  static final String signOut = "Sign Out";

  //Routes
  static final String navigateRoute = "/navigate";
  static final String mathRoute = "/math";
  static final String loginRoute = "/login";

  static final String welcome = "Welcome To BrainFreeze!";


  //Signup page
  static final String signUpRoute = "/signup";
  static final String signUpPage = "Sign Up";
  static final List<int> usernameLength = [8, 128];
  static final List<int> emailLength = [4, 254];
  static final List<int> passwordLength = [8, 128];
  static final List<int> firstNameLength = [2, 35];
  static final List<int> lastNameLength = [2, 35];
  static final List<int> stateLength = [4, 35];
  static final List<int> cityLength = [4, 35];

  static final String email = "Email";
  static final String firstName = "First Name";
  static final String lastName = "Last Name";
  static final String state = "State";
  static final String city = "City";
  static final String confirmPassword = "Confirm Password";
  static final String submit = "Submit";

 
  //SignIn Page
  static final int usernameMinSize = 3;
  static final int passwordMinSize = 8;
  static final String signInPage = "Sign In";
  static final String username = "Username";
  static final String password = "Password";
  static final String errorInvalidUsername = "Invalid Username";
  static final String errorInvalidPassword = "Invalid Password";
  static final String invalidUsernameOrPassword =
      "Invalid Username Or Password";
  static final String signingIn = "Signing In";


  //Math page
  static final String mathPage = "Math";
  static final String statsKeyword = "stats";
  static final String rightKeyword = "right";


  //Leaderboard
  static final String leaderboardPage = "LeaderBoard";
}
