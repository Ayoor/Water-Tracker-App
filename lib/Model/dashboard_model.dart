import 'package:water_tracker/Model/historyData.dart';

import 'CupData.dart';

class DashboardModel {
  int currentNumber = 1;
  String dueDate = "";
  String cupMill = "100ml";
  int currentMill = 0;
  String imagePath = "Assets/water100.png";
  CupData selectedCup =
  CupData(image: "Assets/water100.png", cupMlText: "100ml", cupMil: 100);
  double indicatorPercentage = 0.0;
  List<HistoryData> weeklyHistory = [];
  List<DrinkData> drinkHistory = [];
  // DateTime currentTime = DateTime.now().add(Duration(days: 1));
  DateTime currentTime = DateTime.now();
}