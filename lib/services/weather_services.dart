import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_weather_app_v2/models/weather_model.dart';

class WeatherService {
  // Ideally, store this in a .env file, but for this example, we keep it here.
  static const String apiKey = '6a930ddbe642a7779b28dd6073b1d71d';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$baseUrl?q=$cityName&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      // You can throw more specific errors here based on status code
      throw Exception('Failed to load weather: ${response.statusCode}');
    }
  }
}