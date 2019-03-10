import 'package:flutter/material.dart';
import 'package:brainfreeze/settings/strings.dart';
import 'package:brainfreeze/vulcun_client/vulcun_client.dart';
import 'package:brainfreeze/vulcun_client/settings.dart' as vulcunSettings;
import 'views/basic_views.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpPageState();
  }
}

class SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _username;
  String _email;
  String _firstName;
  String _lastName;
  String _password;
  String _state;
  String _city;
  String _confirmPassword;
  String _error = "";

  bool _validateConfirmPassword() {
    if (_password != _confirmPassword) {
      return false;
    }
    return true;
  }

  String _lengthValidate(String value, List<int> length, String fieldName) {
    if (value.length < length[0]) {
      return "$fieldName Should Atleast Be ${length[0]} Characters";
    } else if (value.length > length[1]) {
      return "$fieldName Should Not Be Moe Than ${length[1]} Characters";
    }
    return null;
  }

  void _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (!_validateConfirmPassword()) {
        setState(() {
          _error = "Confirm Password Should Match Password";
          _autoValidate = true;
        });
      } else {
        setState(() {
          _error = "";
        });

        VulcunClient vulcunClient = VulcunClient(null, null);
        Map response = await vulcunClient.requestForRegistration({
          vulcunSettings.Settings.usernameKeyword :_username,
          vulcunSettings.Settings.passwordKeyword :_password,
          vulcunSettings.Settings.emailKeyword :_email,
          vulcunSettings.Settings.firstNameKeyword :_firstName,
          vulcunSettings.Settings.lastNameKeyword :_lastName,
          vulcunSettings.Settings.citydKeyword :_city,
          vulcunSettings.Settings.stateKeyword :_state,
        });
        if(response[vulcunSettings.Settings.emailKeyword] == "Email Exist"){
          setState(() {
            _error = "Email Exists";
            _autoValidate = true;
          });
        } else if(response[vulcunSettings.Settings.usernameKeyword] == "Username Exist"){
          setState(() {
            _error = "Username Exists";
            _autoValidate = true;
          });
        } else {
          await vulcunClient.saveData();
          Navigator.of(context).pushReplacementNamed(StringsSettings.navigateRoute);
        }
      }
    } else {
      setState(() {
        _error = "";
        _autoValidate = true;
      });
    }
  }

  Widget _formUI() {
    return Form(
        key: _formKey,
        child: Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              TextFormField(
                decoration:
                    InputDecoration(labelText: StringsSettings.username),
                validator: (String value) => _lengthValidate(value,
                    StringsSettings.usernameLength, StringsSettings.username),
                onSaved: (String value) => _username = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: StringsSettings.email),
                validator: (String value) => _lengthValidate(
                    value, StringsSettings.emailLength, StringsSettings.email),
                onSaved: (String value) => _email = value,
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: StringsSettings.firstName),
                validator: (String value) => _lengthValidate(value,
                    StringsSettings.firstNameLength, StringsSettings.firstName),
                onSaved: (String value) => _firstName = value,
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: StringsSettings.lastName),
                validator: (String value) => _lengthValidate(value,
                    StringsSettings.lastNameLength, StringsSettings.lastName),
                onSaved: (String value) => _lastName = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: StringsSettings.state),
                validator: (String value) => _lengthValidate(
                    value, StringsSettings.stateLength, StringsSettings.state),
                onSaved: (String value) => _state = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: StringsSettings.city),
                validator: (String value) => _lengthValidate(
                    value, StringsSettings.cityLength, StringsSettings.city),
                onSaved: (String value) => _city = value,
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: StringsSettings.password),
                validator: (String value) => _lengthValidate(value,
                    StringsSettings.passwordLength, StringsSettings.password),
                onSaved: (String value) => _password = value,
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: StringsSettings.confirmPassword),
                onSaved: (String value) => _confirmPassword = value,
              ),
              Text(_error),
              RaisedButton(
                child: Text(StringsSettings.submit),
                onPressed: _submit,
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getBasicAppBar(StringsSettings.signUpPage, null),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: <Widget>[
              getBasicHeading(StringsSettings.signUpPage),
              _formUI()
            ],
          ),
        ),
      ),
    );
  }
}
