
class CupData {
  String image;
  String cupMlText;
  int cupMil;

  CupData({required this.image, required this.cupMlText, required this.cupMil});

  Map<String, dynamic> toJson() => {
    'image': image,
    'cupMlText': cupMlText,
    'cupMil': cupMil,
  };

  factory CupData.fromJson(Map<String, dynamic> json) => CupData(
    image: json['image'],
    cupMlText: json['cupMlText'],
    cupMil: json['cupMil'],
  );
}

class DrinkData {
  CupData cupData;
  String time;

  DrinkData({required this.cupData, required this.time});

  Map<String, dynamic> toJson() => {
    'cupData': cupData.toJson(),
    'time': time,
  };

  factory DrinkData.fromJson(Map<String, dynamic> json) => DrinkData(
    cupData: CupData.fromJson(json['cupData']),
    time: json['time'],
  );
}
