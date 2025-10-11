class Weather{
  final String cityname;
  final double temperature;
  final String mainCondition;

  Weather({
    required this.cityname,
    required this.temperature,
    required this.mainCondition,
  });
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityname: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
    );
  }

}
