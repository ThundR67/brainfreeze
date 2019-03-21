//Login Page
import 'package:flutter/material.dart';
import 'package:brainfreeze/vulcun_client/vulcun_client.dart';
import 'package:brainfreeze/settings/strings.dart';
import 'views/basic_views.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _usernameFormKey = GlobalKey();
  String _username;
  String _password;
  double _opacity = 0;
  double _progressOpacity = 0;

  void _validateInputs() async {
    setState(() {
      //Showing progress bar
     _progressOpacity = 1; 
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      //Check If Credentials Are Correct
      VulcunClient vulcunClient = VulcunClient(null, null);
      bool isAuth =
          await vulcunClient.requestForAuthenticate(_username, _password);

      if (isAuth) {
        //Credentials Were Correct
        vulcunClient.saveData();
        Navigator.of(context)
            .pushReplacementNamed(StringsSettings.navigateRoute);
      } else {
        setState(() {
         _opacity = 1;
        });
      }
    }
    setState(() {
      //Hiding progress bar
     _progressOpacity = 0; 
    });
  }

  String _validateUsername(String value) {
    if (value.length < StringsSettings.usernameMinSize)
      return StringsSettings.errorInvalidUsername;
    return null;
  }

  String _validatePassword(String value) {
    if (value.length < StringsSettings.passwordMinSize)
      return StringsSettings.errorInvalidPassword;
    return null;
  }

  Widget formUI() {
    return Container(
        margin: EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  key: _usernameFormKey,
                  decoration:
                      InputDecoration(labelText: StringsSettings.username),
                  keyboardType: TextInputType.text,
                  validator: _validateUsername,
                  onSaved: (String value) => {_username = value},
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: StringsSettings.password),
                  obscureText: true,
                  validator: _validatePassword,
                  onSaved: (String value) => {_password = value},
                ),
                Container(height: 32),
                Opacity(child:Text(StringsSettings.invalidUsernameOrPassword), opacity: _opacity),
                Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      RaisedButton(
                        onPressed: _validateInputs,
                        child: Text(StringsSettings.signInPage),
                      ),
                      RaisedButton(
                        onPressed: () => {Navigator.of(context).pushNamed(StringsSettings.signUpRoute)},
                        child: Text(StringsSettings.signUpPage),
                      )
                    ]))
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getBasicAppBar(StringsSettings.signInPage, null),
        body: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Opacity(child: LinearProgressIndicator(), opacity: _progressOpacity),
              Container(height: 8),
              getBasicHeading(StringsSettings.signInPage),
              formUI(),
            ],
          ),
        ));
  }
}
