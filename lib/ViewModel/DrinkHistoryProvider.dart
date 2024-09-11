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
    String lastDrinkTimeString = prefs.getString("lastDrinkTime") ??
        DateTime.now().toString();
    DateTime lastDrinkTime = DateTime.parse(lastDrinkTimeString);
    List<String>? encodedList = prefs.getStringList('drinkHistory');
    if (lastDrinkTime.day != DateTime.now()
        .day) {
      return [];
    }
    else {
      if (encodedList != null) {
        return encodedList
            .map((encodedDrink) => DrinkData.fromJson(jsonDecode(encodedDrink)))
            .toList()
            .reversed
            .toList();
      } else {
        return [];
      }
    }
  }




}

