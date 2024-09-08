import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_tracker/ViewModel/DrinkHistoryProvider.dart';
import '../Model/historyData.dart';

class AnimatedBarGraph extends StatefulWidget {
  const AnimatedBarGraph({super.key});

  @override
  _AnimatedBarGraphState createState() => _AnimatedBarGraphState();
}

class _AnimatedBarGraphState extends State<AnimatedBarGraph> {
  List<HistoryData> weeklyData=[];
  @override
  Widget build(BuildContext context) {


    final historyProvider = Provider.of<DrinkHistoryProvider>(context, listen: false);
    final List<String> xLabels = historyProvider.getLast7days().reversed.toList();


   retrieveWeeklyData();

    final List<double> yValues = historyProvider.sevenDays(weeklyData, historyProvider.getLast7days().reversed.toList());

    double maxYValue = yValues.reduce((a, b) => a > b ? a : b); // Find the maximum y value

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxYValue + 100, // Adjust maxY to be slightly higher than the max value in yValues
        minY: 0,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                int index = value.toInt();
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(xLabels[index], style: const TextStyle(fontSize: 12)),
                );
              },
              interval: 1,
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                // Format the Y-axis values
                return Text('${(value / 1000).toStringAsFixed(1)}k', style: const TextStyle(fontSize: 12));
              },
              interval: 5000, // Adjust the interval based on your data range
              reservedSize: 40,
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey, width: 1),
        ),
        barGroups: yValues.asMap().entries.map((entry) {
          int index = entry.key;
          double value = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value,
                width: 16,
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
        gridData: const FlGridData(show: false),
      ),
      swapAnimationDuration: const Duration(milliseconds: 500),
      swapAnimationCurve: Curves.easeInOut,
    );
  }
  Future<void> retrieveWeeklyData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the list of JSON strings
    List<String>? historyList = prefs.getStringList('historyData');
    if(historyList!=null) {
      // Convert each JSON string back to a HistoryData object
      weeklyData= historyList.map((item) => HistoryData.fromMap(jsonDecode(item))).toList();
    }
    else{
      weeklyData=[];
    }
  }
}
