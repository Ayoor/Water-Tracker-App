import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_tracker/ViewModel/DashboardProvider.dart';
import 'package:water_tracker/ViewModel/DrinkHistoryProvider.dart';
import '../Model/historyData.dart';

class AnimatedBarGraph extends StatefulWidget {
  final List<double>yValues;
   AnimatedBarGraph({super.key, required this.yValues});

  @override
  _AnimatedBarGraphState createState() => _AnimatedBarGraphState();
}

class _AnimatedBarGraphState extends State<AnimatedBarGraph> {
  List<HistoryData> weeklyData=[];
  @override
  Widget build(BuildContext context) {

    final dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
    final List<String> xLabels = dashboardProvider.getLast7days().reversed.toList();


   dashboardProvider.retrieveWeeklyHistoryData();



    double maxYValue = widget.yValues.reduce((a, b) => a > b ? a : b); // Find the maximum y value

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxYValue + 500, // Adjust maxY to be slightly higher than the max value in yValues
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
                if(value >= 1000) {
                  // Format the Y-axis values
                  return Text('${(value / 1000).toStringAsFixed(1)}k',
                      style: const TextStyle(fontSize: 12));
                }
                else{
                  return Text('$value',
                      style: const TextStyle(fontSize: 12));
                }
              },
              interval: 500, // Adjust the interval based on your data range
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
        barGroups: widget.yValues.asMap().entries.map((entry) {
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
        gridData: const FlGridData(show: true, drawVerticalLine: false),
      ),
      swapAnimationDuration: const Duration(milliseconds: 500),
      swapAnimationCurve: Curves.easeInOut,
    );
  }

}
