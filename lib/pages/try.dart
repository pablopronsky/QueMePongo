import 'package:dev/service/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../model/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('bf60016fc2c512c3497f432fc12a01ae');
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    try{
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }catch (e) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(e.toString()),
      );
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition != null) mainCondition = mainCondition.toLowerCase();
    switch(mainCondition) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'dust':
      case 'fog':
        return 'assets/nublado.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/lluvia.json';
      case 'thunderstorm':
        return 'assets/tormenta_electrica.json';
      case 'clear':
        return 'assets/soleado.json';
      default:
        return 'assets/sonrisa.json';
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // busca el tiempo apenas se abre la app
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_weather?.cityName ?? "Buscando tu ubicación..."),
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
              Text('${_weather?.temperature.round()}ºC'),
              Text(_weather?.mainCondition ?? "")
            ],
          ),
        )
    );
  }
}
