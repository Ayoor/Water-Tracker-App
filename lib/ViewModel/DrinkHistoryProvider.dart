import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../Model/CupData.dart';

class DrinkHistoryProvider extends ChangeNotifier {
  List<DrinkData> _drinkHistory = [];

  List<DrinkData> get drinkHistory => _drinkHistory;

  // void addDrinkData(DrinkData drinkData) {
  //   _drinkHistory.add(drinkData);
  //   loadDrinkHistory();
  //   notifyListeners();
  // }

  Future<void> loadDrinkHistory() async {
    _drinkHistory = await retrieveDrinkHistory();
    notifyListeners();
  }

  Future<List<DrinkData>> retrieveDrinkHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList('drinkHistory');
    if (encodedList != null) {
      return encodedList.map((encodedDrink) => DrinkData.fromJson(jsonDecode(encodedDrink))).toList().reversed.toList();
    } else {
      return [];
    }
  }



}

