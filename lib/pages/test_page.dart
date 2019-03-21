import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:brainfreeze/vulcun_client/settings.dart' as vulcunSettings;
import 'submit_page.dart';


/* Takes in mcqs remaining
Shows the first mcq
Then add the option selected to mcqdone
Then removes the mcq from mcqremaining as mcq is answered
sends user to a new test page with new mcq remaining and new mqs done data*/

class TestPage extends StatefulWidget {
  final Map _mcqsRemaining;
  final Map _mcqsDone;
  TestPage(this._mcqsRemaining, this._mcqsDone);
  @override
  State<StatefulWidget> createState() {
    return TestPageState(_mcqsRemaining, _mcqsDone);
  }
}

class TestPageState extends State<TestPage> {
  List _currentOptions;
  String _currentQuestion;
  int _radioValue = 1;
  int _currentId;
  Map _mcqsRemaining;
  Map<String, Map<String,String>> _mcqsDone;
  Map _futureMcqsRemaining = {};


  TestPageState(this._mcqsRemaining, this._mcqsDone);

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  void _loadData() {
    /*loads data
    shows first mcq
    keeps rest of mcq in new mcqs remaining */
    bool firstItemCame = false;
    _mcqsRemaining.forEach((key, value) {
      if (!firstItemCame) {
        _currentId = int.parse(key);
        _currentQuestion = value[vulcunSettings.Settings.questionKeyword];
        _currentOptions = json.decode(value[vulcunSettings.Settings.optionsKeyword].toString());
      } else {
        _futureMcqsRemaining[key.toString()] = value;
      }
      firstItemCame = true;
    });
  }

  Widget _option(int value, String text) {
    return Row(
      children: <Widget>[
        new Radio(
          value: value,
          groupValue: _radioValue,
          onChanged: _handleRadioValueChange,
        ),
        new Text(
          text,
          style: new TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget formUI() {
    List<Widget> options = [];
    for (int i = 0; i < _currentOptions.length; i++) {
      options.add(_option(i, _currentOptions[i].toString()));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: options,
    );
  }

  void _submit() {
    /*Adds option selected and mcq data to new mcq done and redirects user
    to new test page with new mcq remaining and new mcq done */
    if(_mcqsDone == null){
      _mcqsDone = {};
    }
    _mcqsDone[_currentId.toString()] = {
      vulcunSettings.Settings.optionSelectedKeyword : _currentOptions[_radioValue].toString(),
      vulcunSettings.Settings.questionKeyword : _currentQuestion.toString(),
    };

    if(_futureMcqsRemaining.length == 0){
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SubmitPage(_mcqsDone)));
    } else {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => TestPage(_futureMcqsRemaining, _mcqsDone)));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 16.0),
          child: Column(
            children: <Widget>[
              Container(
                height: 80.0,
              ),
              Text(
                _currentQuestion,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              Container(
                height: 8.0,
              ),
              Divider(),
              Container(
                height: 8.0,
              ),
              formUI(),
              RaisedButton(
                child: Text("Submit"),
                onPressed: _submit,
              )
            ],
          ),
        ),
      ),
    );
  }
}
