import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Time in 3 Hours'),
        ),
        body: Center(
          child: TimeIn3Hours(),
        ),
      ),
    );
  }
}

class TimeIn3Hours extends StatelessWidget {
  String _getTimeIn3Hours() {
    DateTime now = DateTime.now();
    DateTime futureTime = now.add(Duration(hours: 3));
    String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(futureTime);
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Time in 3 hours: ${_getTimeIn3Hours()}',
      style: TextStyle(fontSize: 20),
    );
  }
}
