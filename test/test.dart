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
  print(getLast7days().reversed);


  List<String>last7Days = [];
  sevenDays(sevenWeekHistory, getLast7days());

  // print(last7Days);
  // print(getLast7DaysHistory(sevenWeekHistory, last7Days));
}
List<String> getLast7days(){
  List<String> last7Days = [];
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
  return last7Days;
}

List<int> getLast7DaysHistory(List<HistoryData> history, List<String> last7Days){
  List<int> waterIntakeVolumePerDay = [];
  for(int i = 0; i < 7; i++) {
    if(history[i].date != last7Days.reversed.toList()[i]){
      history[i].totalWaterMl = 0;
    }
     }
  return waterIntakeVolumePerDay;
}

void sevenDays(List<HistoryData> history, List<String> last7Days){
  List<int> waterIntakeVolumePerDay = [];
  for(int i = 0; i < 7; i++) {
    if(history[i].date != last7Days.reversed.toList()[i]){
      waterIntakeVolumePerDay.add(0);
    }
    else{
      waterIntakeVolumePerDay.add(history[i].totalWaterMl as int);
    }
  }
  print(waterIntakeVolumePerDay);
}

