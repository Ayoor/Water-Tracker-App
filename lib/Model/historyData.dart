class HistoryData {
  final String date;
  late final double totalWaterMl;
  final List<double> yValues =[];

  HistoryData({required this.date, required this.totalWaterMl});

  // Convert a HistoryData object to a Map
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'totalWaterMl': totalWaterMl,
    };
  }

  // Create a HistoryData object from a Map
  factory HistoryData.fromMap(Map<String, dynamic> map) {
    return HistoryData(
      date: map['date'],
      totalWaterMl: map['totalWaterMl'],
    );
  }
}
