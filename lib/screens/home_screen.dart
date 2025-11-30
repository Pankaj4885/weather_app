import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:my_weather_app_v2/providers/weather_provider.dart';
import 'package:my_weather_app_v2/models/weather_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Helper to format Unix timestamp to Time (e.g., 6:30 AM)
  String formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('jm').format(date);
  }

  // Determine background gradient based on weather condition
  LinearGradient getBackgroundGradient(String? condition) {
    if (condition == null) {
      return const LinearGradient(
        colors: [Colors.blueGrey, Colors.grey],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }

    switch (condition.toLowerCase()) {
      case 'rain':
      case 'drizzle':
      case 'thunderstorm':
        return const LinearGradient(
          colors: [Color(0xFF616161), Color(0xFF9BC5C3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'clear':
        return const LinearGradient(
          colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'clouds':
        return const LinearGradient(
          colors: [Color(0xFF757F9A), Color(0xFFD7DDE8)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF4CA1AF), Color(0xFFC4E0E5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the provider state
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final weather = weatherProvider.weather;

    return Scaffold(
      // The body extends behind the AppBar for a full-screen look
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Weather View', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: getBackgroundGradient(weather?.mainCondition),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // SEARCH BAR
                TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter City Name (e.g. London)',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        // Trigger the provider to fetch data
                        FocusScope.of(context).unfocus(); // Close keyboard
                        weatherProvider.fetchWeather(_controller.text);
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    FocusScope.of(context).unfocus();
                    weatherProvider.fetchWeather(value);
                  },
                ),

                const SizedBox(height: 20),

                // CONTENT AREA
                Expanded(
                  child: weatherProvider.isLoading
                      ? const Center(child: CircularProgressIndicator(color: Colors.white))
                      : weatherProvider.error != null
                      ? Center(
                    child: Text(
                      weatherProvider.error!,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                      : weather == null
                      ? const Center(
                    child: Text(
                      'Search for a city to start',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  )
                      : SingleChildScrollView(
                    child: Column(
                      children: [
                        // Main Weather Icon / Lottie
                        const SizedBox(height: 20),
                        // TODO: Replace this Icon with Lottie.asset('assets/...') based on weather.mainCondition
                        Icon(
                            weather.mainCondition.toLowerCase() == 'clear' ? Icons.wb_sunny :
                            weather.mainCondition.toLowerCase() == 'clouds' ? Icons.cloud :
                            Icons.umbrella,
                            size: 100,
                            color: Colors.white
                        ),

                        const SizedBox(height: 10),
                        Text(
                          weather.cityName,
                          style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                        Text(
                          '${weather.temperature.toStringAsFixed(1)}°C',
                          style: const TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.w300,
                              color: Colors.white
                          ),
                        ),
                        Text(
                          weather.description.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 20,
                              letterSpacing: 1.2,
                              color: Colors.white70
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Details Grid
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          children: [
                            _buildInfoCard("Humidity", "${weather.humidity}%", Icons.water_drop),
                            _buildInfoCard("Wind", "${weather.windSpeed} m/s", Icons.air),
                            _buildInfoCard("Sunrise", formatTime(weather.sunrise), Icons.wb_twilight),
                            _buildInfoCard("Sunset", formatTime(weather.sunset), Icons.nights_stay),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable Widget for Detail Cards
  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }
}