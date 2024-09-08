import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../Model/CupData.dart';
import '../Model/historyData.dart';

class DrinkHistoryProvider extends ChangeNotifier {
  List<DrinkData> _drinkHistory = [];

  List<DrinkData> get drinkHistory => _drinkHistory;


  Future<void> loadDrinkHistory() async {
    _drinkHistory = await retrieveDrinkHistory();
    notifyListeners();
  }

  Future<List<DrinkData>> retrieveDrinkHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String lastDrinkTimeString = prefs.getString("lastDrinkTime") ?? DateTime.now().toString();
    // DateTime lastDrinkTime = DateTime.parse(lastDrinkTimeString);
    List<String>? encodedList = prefs.getStringList('drinkHistory');

    if (encodedList != null) {
      return encodedList.map((encodedDrink) => DrinkData.fromJson(jsonDecode(encodedDrink))).toList().reversed.toList();
    } else {
      return [];
    }
  }


  List<double> sevenDays(List<HistoryData> history, List<String> last7Days){
    List<double> waterIntakeVolumePerDay = [];
    if(history.isNotEmpty){
    for(int i = 0; i < 7; i++) {
      if(history[i].date != last7Days[i]){
        waterIntakeVolumePerDay.add(0);
      }
      else{
        waterIntakeVolumePerDay.add(history[i].totalWaterMl);
      }
    }
    }

    return waterIntakeVolumePerDay;
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


}

