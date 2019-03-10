import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:brainfreeze/vulcun_client/vulcun_client.dart';
import 'package:brainfreeze/settings/strings.dart';


class SubmitPage extends StatefulWidget {
  final Map _mcqsDone;

  SubmitPage(this._mcqsDone);

  @override
  State<StatefulWidget> createState() {
    return SubmitPageState(_mcqsDone);
  }
}

class SubmitPageState extends State<SubmitPage> {
  Map _mcqsDone;
  bool _isSubmited = false;
  List<Widget> _widgets = [];

  SubmitPageState(this._mcqsDone);

  void _submitData() async {
    VulcunClient vulcunClient = VulcunClient(null, null);
    await vulcunClient.retreiveData();
    Map<String, dynamic> response = await vulcunClient
        .requestForVerifyMCQReciept(StringsSettings.mathSubject, json.encode(_mcqsDone));

    setState(() {
      response.forEach((key, value) {
        _widgets.add(Text("$key Question Was $value",
        style:TextStyle(fontSize: 24.0)));
      });
      _isSubmited = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isSubmited) {
      _submitData();
    }
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Column(
        children: <Widget>[
          Container(height: 80),
          !_isSubmited
                  ? CircularProgressIndicator()
                  : Column(children: _widgets),
            RaisedButton(child: Text("Done"), onPressed: () {Navigator.of(context).pushNamed(StringsSettings.navigateRoute);},)
        ],
      ),
    )));
  }
}
