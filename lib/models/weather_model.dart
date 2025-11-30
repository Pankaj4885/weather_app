class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition; // Main weather (Rain, Clear, Clouds)
  final String description;
  final int humidity;
  final double windSpeed;
  final int sunrise; // Unix timestamp
  final int sunset;  // Unix timestamp

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? '',
      // Convert Kelvin to Celsius safely
      temperature: (json['main']['temp'] as num).toDouble() - 273.15,
      mainCondition: json['weather'][0]['main'] ?? '',
      description: json['weather'][0]['description'] ?? '',
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      sunrise: json['sys']['sunrise'] ?? 0,
      sunset: json['sys']['sunset'] ?? 0,
    );
  }
}