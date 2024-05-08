import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weathe_app/models/models.dart';
import 'package:weathe_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('6d9bed988e0a8becf18439c27f05ec06');
  WeatherModel? _weatherModel;
  final _searchController = TextEditingController();

  _fetchWeather(String cityName) async {
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weatherModel = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String GetWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/sun.json';
    }
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain ':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/rain.json';
      default:
        return 'assets/sun.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentCity();
  }

  _getCurrentCity() async {
    final cityName = await _weatherService.getCurrentCity();
    _fetchWeather(cityName);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade300,
              Colors.blue.shade900,
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 70.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Enter city name',
                  hintStyle: const TextStyle(color: Colors.blueGrey),
                  filled: true,
                  fillColor: Colors.blue.shade100.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.blueGrey),
                    onPressed: () {
                      _fetchWeather(_searchController.text);
                    },
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weatherModel?.cityName ?? 'Loading City...',
                    style: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Lottie.asset(
                    GetWeatherAnimation(_weatherModel?.mainCondition),
                    height: 200.0,
                    width: 200.0,
                  ),
                  const SizedBox(height: 40.0),
                  Text(
                    '${_weatherModel?.temp.round()} °C',
                    style: const TextStyle(
                      fontSize: 48.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    _weatherModel?.mainCondition ?? 'Loading Condition...',
                    style: const TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
