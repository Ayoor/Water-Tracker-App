import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_tracker/Model/dashboard_model.dart';
import 'package:water_tracker/Model/historyData.dart';

import '../Model/CupData.dart';

class DashboardProvider extends ChangeNotifier {
  // *************************************
  // -- variable declarations --
  // *************************************

  final DateTime _currentTime = DashboardModel().currentTime;

  DateTime get currentTime => _currentTime;

  String _dueDate = DashboardModel().dueDate;

  String get dueDate => _dueDate;

  int _currentMill = DashboardModel().currentMill;

  int get currentMill => _currentMill;

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

  List<HistoryData> _weeklyData = DashboardModel().weeklyHistory;

  List<HistoryData> get weeklyData => _weeklyData;
  
  // *************************************
  // -- load Current Water Intake Status --
  // *************************************

  void loadCurrentWaterIntakeStatus() async {
    String formatedTime;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // load the saved list
    DateTime lastDrinkTime = await _getLastDrinkTime();

    if (currentTime.day == lastDrinkTime.day) {
      if (currentTime.isAfter(lastDrinkTime)) {
        _dueDate = "Due";
        _currentMill = (prefs.getInt('currentMill') ?? 0);
      } else {
        _currentMill = (prefs.getInt('currentMill') ?? 0);
        formatedTime = DateFormat('h:mm a').format(lastDrinkTime);
        _dueDate = formatedTime;
      }
    } else {
      _currentMill = 0;
      _dueDate = "Due";
    }
    prefs.setString("LastOpened", _currentTime.toString());
    setIndicatorPercentage();
    notifyListeners();
  }

  // *************************************
  // -- fetch time of last drink --
  // *************************************

  Future<DateTime> _getLastDrinkTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastDrinkTimeString = prefs.getString("lastDrinkTime");
    DateTime lastDrinkTime;

    if (lastDrinkTimeString != null) {
      lastDrinkTime = DateTime.parse(lastDrinkTimeString);
    } else {
      lastDrinkTime = currentTime.subtract(const Duration(days: 1));
    }
    return lastDrinkTime;
  }

  Future<DateTime> _getLastAppOpened() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastTimeOpenedString = prefs.getString("LastOpened");
    DateTime lastTimeOpened;

    if (lastTimeOpenedString != null) {
      lastTimeOpened = DateTime.parse(lastTimeOpenedString);
    } else {
      lastTimeOpened = currentTime.subtract(const Duration(minutes: 1));
    }
    return lastTimeOpened;
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
    _currentMill += _selectedCup.cupMil * _currentNumber;
    _cupMill = "${_selectedCup.cupMil * _currentNumber}ml";
    setIndicatorPercentage();
    notifyListeners();

    //save in memory
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('currentMill', _currentMill);

    _dueDate = DateFormat('h:mm a').format(getNextDrinkTime());
    String nextDrinkTime = getNextDrinkTime().toString();
    prefs.setString('futureTime', nextDrinkTime);

    DrinkData drinkData = DrinkData(
        cupData:
            CupData(image: _imgPath, cupMil: _currentMill, cupMlText: _cupMill),
        time: getCurrentTime());

    DateTime lastDrinkTime = await _getLastDrinkTime();
    retrieveWeeklyHistoryData();

    DateTime lastAppOpen = await _getLastAppOpened();
    if (_currentTime.day == lastAppOpen.day) {
      _drinkHistory = await _retrieveDrinkHistory();

      _weeklyData[_weeklyData.length - 1] = (HistoryData(
            date: "${_currentTime.day}/${_currentTime.month}",
            totalWaterMl: _currentMill.toDouble()));

    } else {
      //save to weekly list before deleting
      if (_weeklyData.length != 7) {
        _weeklyData.add(HistoryData(
            date: "${_currentTime.day}/${_currentTime.month}",
            totalWaterMl: _currentMill.toDouble()));
      } else {
        _weeklyData.removeAt(0);
        _weeklyData.add(HistoryData(
            date: "${_currentTime.day}/${_currentTime.month}",
            totalWaterMl: _currentMill.toDouble()));
      }
      _drinkHistory = [];
    }
    _drinkHistory.add(drinkData);
    prefs.setString('lastDrinkTime', _currentTime.toString());

    // Convert the list of HistoryData to a list of Maps
    List<String> historyList =
        _weeklyData.map((data) => jsonEncode(data.toMap())).toList();

    // Save the list of JSON strings
    prefs.setStringList('historyData', historyList);

    saveDrinkHistory(_drinkHistory);
    _showToast("Happy Drinking");

    notifyListeners();
  }



  void retrieveWeeklyHistoryData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
        // Retrieve the list of JSON strings
    List<String>? historyList = prefs.getStringList('historyData');

    if (historyList != null) {
      // Convert each JSON string back to a HistoryData object
      _weeklyData = historyList
          .map((item) => HistoryData.fromMap(jsonDecode(item)))
          .toList();
    } else {
      _weeklyData = [];
    }
    if(_weeklyData.isEmpty){
      _weeklyData.add(HistoryData(
          date: "${_currentTime.day}/${_currentTime.month}",
          totalWaterMl: 0.0));
    }
    else{
      DateTime lastTimeAppOpened = await _getLastAppOpened();

      if (_currentTime.day == lastTimeAppOpened.day) {

        _weeklyData[_weeklyData.length - 1] = (HistoryData(
              date: "${_currentTime.day}/${_currentTime.month}",
              totalWaterMl: _currentMill.toDouble()));

      } else {
          _currentMill =0;
        if (_weeklyData.length != 7) {
          _weeklyData.add(HistoryData(
              date: "${_currentTime.day}/${_currentTime.month}",
              totalWaterMl: _currentMill.toDouble()));
        }

        else {
          _weeklyData.removeAt(0);
          _weeklyData.add(HistoryData(
              date: "${_currentTime.day}/${_currentTime.month}",
              totalWaterMl: _currentMill.toDouble()));
        }
          lastTimeAppOpened = _currentTime.subtract(const Duration(milliseconds: 500));
       prefs.setString("LastOpened", "$lastTimeAppOpened") ;
      }
      // Convert the list of HistoryData to a list of Maps
      List<String> historyList =
      _weeklyData.map((data) => jsonEncode(data.toMap())).toList();
    }
    historyList =_weeklyData.map((data) => jsonEncode(data.toMap())).toList();

    // Save the list of JSON strings
    prefs.setStringList('historyData', historyList);
   

    // Retrieve the list of JSON strings
    // List<String>? h = prefs.getStringList('historyData');
    // if(h!=null) {
    //   // Convert each JSON string back to a HistoryData object
    //   _weeklyData= historyList.map((item) => HistoryData.fromMap(jsonDecode(item))).toList();
    //   print("Saved Data: ${_weeklyData[0].date} with size of ${_weeklyData.length}");
    //
    //
    // }
    // else{
    //   _weeklyData=[];
    //   print("Weekly Data empty");
    // }
notifyListeners();
  }

  // *************************************
  // -- set Indicator Percentage --
  // *************************************

  void setIndicatorPercentage() {
    if (_currentMill > 1500) {
      _indicatorPercentage = 1.0;
    } else {
      _indicatorPercentage = ((currentMill / 1500) * 100) / 100;
    }
  }

  // *************************************
  // -- get time for when the next drink is due--
  // *************************************

  DateTime getNextDrinkTime() {
    DateTime currentTime = _currentTime;
    DateTime nextDrinkTime = currentTime.add(const Duration(hours: 3));

    return nextDrinkTime;
  }

  // *************************************
  // -- get date --
  // *************************************

  String getDate() {
    final formatter = DateFormat('dd/MM/yyy'); // Year-Month-Day format
    String formattedDate = formatter.format(_currentTime);
    return formattedDate;
  }

  String getCurrentTime() {
    DateTime currentTime = _currentTime;
    String nextDueTime = DateFormat('h:mm a').format(currentTime);
    return nextDueTime;
  }

  Future<List<DrinkData>> _retrieveDrinkHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList('drinkHistory');
    if (encodedList != null) {
      _drinkHistory = encodedList
          .map((encodedDrink) => DrinkData.fromJson(jsonDecode(encodedDrink)))
          .toList();
      return drinkHistory;
    } else {
      return [];
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // *************************************
  // -- save drink history to memory --
  // *************************************
  Future<void> saveDrinkHistory(List<DrinkData> drinkHistory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedList =
        drinkHistory.map((drink) => jsonEncode(drink.toJson())).toList();
    await prefs.setStringList('drinkHistory', encodedList);
  }

  List<double> sevenDays(List<HistoryData> history, List<String> last7Days){
    List<double> waterIntakeVolumePerDay = [];
    history = history.reversed.toList();
    if(history.length <7){
      for(int i = history.length; i < 7; i++){
        history.add(HistoryData(date: "", totalWaterMl: 0));
      }

    }
    history = history.reversed.toList();
    for(int i = 0; i < 7; i++) {
      if(history[i].date != last7Days[i]){
        waterIntakeVolumePerDay.add(0);
      }
      else{
        waterIntakeVolumePerDay.add(history[i].totalWaterMl);
      }
    }


    return waterIntakeVolumePerDay;
  }
  List<String> getLast7days(){
    List<String> last7Days = [];
    String date;
    for (int i = 0; i < 7; i++) {
      date = "${_currentTime
          .subtract(Duration(days: i))
          .day}/${_currentTime
          .subtract(Duration(days: i))
          .month}";
      // print("date: $date");
      last7Days.add(date);
    }


    return last7Days;
  }

}
