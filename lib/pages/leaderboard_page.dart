import 'package:flutter/material.dart';
import 'package:brainfreeze/vulcun_client/vulcun_client.dart';
import 'package:brainfreeze/settings/strings.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LeaderboardPageState();
  }
}

class LeaderboardPageState extends State<LeaderboardPage> {
  Map<String, dynamic> _boardData;
  bool _isLoading = true;
  bool _isError = false;

  Future<void> _loadBoardData() async {
    //Loads data
    VulcunClient vulcunClient = VulcunClient(null, null);
    await vulcunClient.retreiveData();
    Map<String, dynamic> response =
        await vulcunClient.requestForMCQSLeaderboard();
    if (response == null) _isError = true;
    setState(() {
      _boardData = response;
      _isLoading = false;
    });
  }

  List<Widget> _board() {
    /*Gets board Data As Map
    Loops over each user and puts it in a list*/
    if (_boardData == null && !_isError) {
      return [Text("No LeaderBoard Data As Of Now")];
    } else if (_isError) {
      return [StringsSettings.noInternet];
    }
    List<Widget> board = [];
    _boardData.forEach((key, value) {
      board.add(Row(children: <Widget>[
        Text("${int.parse(key) + 1} ${value[1]} ${value[2]} ${value[3]}"),
      ]));
    });
    return board;
  }

  @override
  void initState() {
    super.initState();
    _loadBoardData();
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
                        onRefresh: _loadBoardData,
                        child: ListView(
                          children: _board(),
                        ),
                      ))
                    ]),
            ],
          ),
        ),
      ),
    );
  }
}
