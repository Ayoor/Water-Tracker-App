import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HistoryChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        maxY: 30000,
            lineBarsData: [
              LineChartBarData(
                color: Colors.orangeAccent,
                barWidth: 3,
                isCurved: true
              )
        ],
        titlesData:  FlTitlesData(
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false)
          ),
          rightTitles: AxisTitles( sideTitles: SideTitles(showTitles: false)),
          // leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true), axisNameWidget: Text("Water ")),
          bottomTitles: AxisTitles(axisNameWidget: Text("Past Week"), sideTitles: SideTitles()),
        )
      ),
    );
  }
}


