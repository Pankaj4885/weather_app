import 'package:flutter/material.dart';
import 'package:my_weather_app_v2/models/weather_model.dart';
import 'package:my_weather_app_v2/services/weather_services.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  Weather? _weather;
  bool _isLoading = false;
  String? _error;

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWeather(String cityName) async {
    if (cityName.isEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners(); // This tells the UI: "Hey, I'm loading now!"

    try {
      _weather = await _weatherService.fetchWeather(cityName);
    } catch (e) {
      _error = "Could not find city or connection failed.";
      _weather = null;
    } finally {
      _isLoading = false;
      notifyListeners(); // This tells the UI: "I'm done, update the screen!"
    }
  }
}