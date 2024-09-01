import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_tracker/Model/dashboard_model.dart';

import '../Model/CupData.dart';

class DashboardProvider extends ChangeNotifier{

  // *************************************
  // -- variable declarations --
  // *************************************
  final DateTime _currentTime = DashboardModel().currentTime;
  DateTime get currentTime => _currentTime;

  String _dueDate= DashboardModel().dueDate;
  String get dueDate => _dueDate;

  int _drinkMill = DashboardModel().currentMill;
  int get currentMill => _drinkMill;

  int _currentNumber = DashboardModel().currentNumber;
  int get currentNumber => _currentNumber;

  String _imgPath = DashboardModel().imagePath;
  String get imgPath => _imgPath;

  String _cupMill = DashboardModel().cupMill;
  String get cupMill => _cupMill;

  final CupData _selectedCup = DashboardModel().selectedCup;
  CupData get selectedCup => _selectedCup;

  List<DrinkData> _drinkHistory = DashboardModel().drinkHistory;
  List<DrinkData> get drinkHistory => _drinkHistory;

  double _indicatorPercentage = DashboardModel().indicatorPercentage;
  double get indicatorPercentage => _indicatorPercentage;

  // *************************************
  // -- load Current Water Intake Status --
  // *************************************

  void loadCurrentWaterIntakeStatus() async {
    String formatedTime;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // load the saved list
    DateTime lastDrinkTime = await _getLastDrinkTime();

    if(currentTime.day == lastDrinkTime.day){
      if (currentTime.isAfter(lastDrinkTime)) {
        _dueDate = "Due";
        _drinkMill = (prefs.getInt('currentMill') ?? 0);
         } else {
        _drinkMill = (prefs.getInt('currentMill') ?? 0);
        formatedTime =  DateFormat('h:mm a').format(lastDrinkTime);
        _dueDate = formatedTime;

      }
    }
    else{
      _drinkMill = 0;
      _dueDate = "Due";

    }
    setIndicatorPercentage();
    notifyListeners();
  }

  // *************************************
  // -- fetch time of last drink --
  // *************************************

  Future<DateTime> _getLastDrinkTime() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastDrinkTimeString = prefs.getString("lastDrinkTime");
    DateTime lastDrinkTime;

    if (lastDrinkTimeString != null) {
      lastDrinkTime = DateTime.parse(lastDrinkTimeString);

    } else {
      lastDrinkTime = currentTime.subtract(const Duration(minutes: 1));
    }
    return lastDrinkTime;
  }

  // *************************************
  // -- incrementing and decrement cup quantity --
  // *************************************

  void decrement() {
    if (_currentNumber > 1) {

      _currentNumber--;
      notifyListeners();
    }
  }

  void increment() {
    _currentNumber++;
    notifyListeners();
  }
  // *************************************
  // -- manually editing the quantity --
  // *************************************
  void onChanged(String value) {
    _currentNumber = int.tryParse(value) ?? 0;
    notifyListeners();
  }

  // *************************************
  // -- Changing the cup --
  // *************************************
  onItemSelected(CupData selectedItem) {
    _imgPath = selectedItem.image;
    _cupMill = selectedItem.cupMlText;
    _selectedCup.cupMil = selectedItem.cupMil;
    notifyListeners();
  }

  // *************************************
  // -- drink function --
  // *************************************

  void drink() async {
    _drinkMill += _selectedCup.cupMil * _currentNumber;
    _cupMill = "${_selectedCup.cupMil * _currentNumber}ml";
    setIndicatorPercentage();
    notifyListeners();

    //save in memory
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('currentMill', _drinkMill);

    _dueDate =  DateFormat('h:mm a').format(getNextDrinkTime());
    String nextDrinkTime = getNextDrinkTime().toString();
    prefs.setString('futureTime', nextDrinkTime);

    DrinkData drinkData = DrinkData(
        cupData: CupData(
            image: _imgPath, cupMil: _drinkMill, cupMlText: _cupMill),
        time: getCurrentTime());


    DateTime lastDrinkTime = await _getLastDrinkTime();
    if(_currentTime.day == lastDrinkTime.day) {
      _drinkHistory = await _retrieveDrinkHistory();
    }else{
      _drinkHistory= [];
    }
    _drinkHistory.add(drinkData);
    prefs.setString('lastDrinkTime', _currentTime.toString());

    try {
      saveDrinkHistory(_drinkHistory);
      _showToast("Happy Drinking");

    }
    catch (e){
      _showToast("An error occurred please try again later");
    }
    notifyListeners();

  }

  // *************************************
  // -- set Indicator Percentage --
  // *************************************

  void setIndicatorPercentage() {
    if (_drinkMill > 1500) {
      _indicatorPercentage = 1.0;
    } else {
      _indicatorPercentage = ((currentMill / 1500) * 100) / 100;
    }
  }

  // *************************************
  // -- get time for when the next drink is due--
  // *************************************

  DateTime getNextDrinkTime() {
    DateTime currentTime = DateTime.now();
    DateTime nextDrinkTime = currentTime.add(const Duration(hours: 3));

    return nextDrinkTime;
  }

  // *************************************
  // -- get date --
  // *************************************

  String getDate(){
    final formatter = DateFormat('dd/MM/yyy'); // Year-Month-Day format
    String formattedDate = formatter.format(DateTime.now());
    return formattedDate;
  }

  String getCurrentTime(){
    DateTime currentTime = DateTime.now();
    String nextDueTime = DateFormat('h:mm a').format(currentTime);
    return nextDueTime;
  }


  Future<List<DrinkData>> _retrieveDrinkHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList('drinkHistory');
    if (encodedList != null) {
      _drinkHistory= encodedList.map((encodedDrink) => DrinkData.fromJson(jsonDecode(encodedDrink))).toList();
      return drinkHistory;
    }
    else {
      return [];
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  // *************************************
  // -- save drink history to memory --
  // *************************************
  Future<void> saveDrinkHistory(List<DrinkData> drinkHistory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedList = drinkHistory.map((drink) => jsonEncode(drink.toJson())).toList();
    await prefs.setStringList('drinkHistory', encodedList);
  }


}