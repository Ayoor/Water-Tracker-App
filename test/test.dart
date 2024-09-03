import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:water_tracker/Model/historyData.dart';

void main() {
  List<HistoryData> sevenWeekHistory = [
    HistoryData(date: '27/8', totalWaterMl: 1800),
    HistoryData(date: '28/8', totalWaterMl: 1800),
    HistoryData(date: '29/8', totalWaterMl: 1800),
    HistoryData(date: '30/8', totalWaterMl: 1800),
    HistoryData(date: '31/8', totalWaterMl: 1800),
    HistoryData(date: '1/9', totalWaterMl: 1800),
    HistoryData(date: '2/9', totalWaterMl: 1800),


  ];
  print(sevenWeekHistory.reversed);

  int count = 0;
  List<String>last7Days = [];
  String date;
  for (int i = 0; i < 7; i++) {
    date = "${DateTime
        .now()
        .subtract(Duration(days: i))
        .day}/${DateTime
        .now()
        .subtract(Duration(days: i))
        .month}";
    // print("date: $date");
    last7Days.add(date);
  }
  // print(last7Days);
  checkLast7DaysData(sevenWeekHistory, last7Days);
}
  void checkLast7DaysData(List<HistoryData> history, List<String> last7Days){
    for(int i = 0; i < 7; i++) {
      if(history[i].date == last7Days.reversed.toList()[i]){
        print("Match");
      }
      else{
        print("No Match");
      }
    }
  }


