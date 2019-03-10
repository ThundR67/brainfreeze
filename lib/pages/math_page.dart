import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:brainfreeze/vulcun_client/vulcun_client.dart';
import 'package:brainfreeze/vulcun_client/settings.dart' as vulcunSettings;
import 'package:brainfreeze/settings/strings.dart';
import 'views/statistic_view.dart';
import 'test_page.dart';

String topicToName(String topic) {
  //Converts topic name came from server to an actual name presentable to user
  return topic.replaceAll("_", " ");
}

class MathPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MathPageState();
  }
}

class MathPageState extends State<MathPage> {
  Map<String, dynamic> _stats;
  bool _isLoading = true;

  void _giveTest() async {
    //Gets mcqs and then sends user to give the test
    VulcunClient vulcunClient = VulcunClient(null, null);
    await vulcunClient.retreiveData();
    Map mcqs = await vulcunClient
        .requestForMCQSGenerateMCQS(StringsSettings.mathSubject);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TestPage(mcqs, null)));
  }

  void _loadStatisticsData() async {
    VulcunClient vulcunClient = VulcunClient(null, null);
    await vulcunClient.retreiveData();
    Map response =
        await vulcunClient.requestForViewUserData(vulcunClient.currentUsername);

    setState(() {
      print(response);
      this._stats = json.decode(
              response[vulcunSettings.Settings.trackingKeyword]
                  .toString()
                  .replaceAll("'", '"'))[
          "${StringsSettings.mathSubject}_${StringsSettings.statsKeyword}"];
      if(_stats == null){
        _stats = {"MOCK" : "MOCK"};
      }
    });

  }

  List<Widget> _buildStatistics() {
    List<Widget> statViews = [];

    if(_stats["MOCK"] == "MOCK"){
      return [Text("No Data. Give Some MCQS")];
    }

    _stats.forEach((subject, value) {
      if (!subject.contains("_${StringsSettings.rightKeyword}")) {
        statViews.add(getStatisticWidget(
          topicToName(subject),
          value,
          _stats["${subject}_${StringsSettings.rightKeyword}"],
        ));
      }
    });

    return statViews;
  }

  @override
  Widget build(BuildContext context) {
    if (_stats == null) {
      _loadStatisticsData();
      print(_stats);
    }
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(8.0),
          child: Stack(
            children: <Widget>[
              _stats==null
                  ? CircularProgressIndicator()
                  : Column(children: this._buildStatistics()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _giveTest,
        child: Icon(Icons.arrow_right),
      ),
    );
  }
}
