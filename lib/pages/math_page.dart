import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:brainfreeze/vulcun_client/vulcun_client.dart';
import 'package:brainfreeze/vulcun_client/settings.dart' as vulcunSettings;
import 'package:brainfreeze/settings/strings.dart';
import 'package:brainfreeze/cache_manager.dart';
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
  bool _error = false;
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

  Future<void> loadStatisticsData() async {
    //Loads Sata
    VulcunClient vulcunClient = VulcunClient(null, null);
    await vulcunClient.retreiveData();
    Map<String, dynamic> data = await cacheManaged(StringsSettings.mathPage,
        vulcunClient.requestForViewUserData, vulcunClient.currentUsername);
    if (data == null) _error = true;
    Map tracking = json.decode(data[vulcunSettings.Settings.trackingKeyword]
        .toString()
        .replaceAll("'", '"'));
    setState(() {
      _isLoading = false;
      this._stats = tracking[
          "${StringsSettings.mathSubject}_${StringsSettings.statsKeyword}"];
    });
  }

  List<Widget> _buildStatistics() {
    /*Loops over each topic in stats
    Adss the accuracy and other data in list as a text widget*/
    List<Widget> statViews = [];
    if (_stats == null && !_error) {
      return [Text("No Data. Give Some MCQS")];
    } else if (_error) {
      return [StringsSettings.noInternet];
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
  void initState() {
    super.initState();
    loadStatisticsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(8.0),
          child: Stack(
            children: <Widget>[
              _isLoading
                  ? CircularProgressIndicator()
                  : Column(children: [
                      Expanded(
                          child: RefreshIndicator(
                        onRefresh: loadStatisticsData,
                        child: ListView(
                          children: _buildStatistics(),
                        ),
                      ))
                    ]),
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
