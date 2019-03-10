import 'package:flutter/material.dart';
import 'package:brainfreeze/vulcun_client/vulcun_client.dart';
import 'dart:convert';

class LeaderboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LeaderboardPageState();
  }
}

class LeaderboardPageState extends State<LeaderboardPage> {
  Map _boardData;

  void _loadBoardData() async {
    VulcunClient vulcunClient = VulcunClient("null", "null");
    await vulcunClient.retreiveData();
    var response = await vulcunClient.requestForMCQSLeaderboard();
    setState(() {
      _boardData = response;
    });
  }

  List<Widget> _board() {
    List<Widget> board = [];
    _boardData.forEach((key, value) {
      board.add(Row(children: <Widget>[
        Text("${int.parse(key) + 1} ${value[1]} ${value[2]} ${value[3]}"),
      ]));
    });

    return board;
  }

  @override
  Widget build(BuildContext context) {
    if (_boardData == null) this._loadBoardData();
    print(this._board);
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(8.0),
          child: Stack(
            children: <Widget>[
              _boardData == null
                  ? CircularProgressIndicator()
                  : Card(
                      child: Column(
                        children: this._board(),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
