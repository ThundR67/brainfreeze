import 'package:flutter/material.dart';
import 'basic_views.dart';

Widget getStatisticWidget(String topicName, int total, int right) {
  return Card(
    child: Center(
      child: Container(
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            getBasicHeading(topicName),
            Container(height: 8.0,),
            Text(
                "You Got $right Out $total Right, ${((right / total) * 100).toInt()}% Accuracy"),
            Container(height: 8.0,),
            Slider(
              activeColor: Colors.indigoAccent,
              min: 0.0,
              max: total.toDouble(),
              value: right.toDouble(),
              onChanged: (double value) => null,
            ),
          ],
        ),
      ),
    ),
  );
}
