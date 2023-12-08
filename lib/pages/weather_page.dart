import 'dart:async';
import 'package:dev/service/weather_service.dart';
import 'package:flutter/material.dart';
import '../model/weather_model.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('bf60016fc2c512c3497f432fc12a01ae');
  Weather? _weather;
  String _suggestedClothing = "";
  bool _isLoading = true;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _suggestedClothing = _getSuggestedClothing(
          temperature: weather.temperature,
          mainCondition: weather.mainCondition.toLowerCase(),
        );
        _isLoading = false; // Indica que la carga ha terminado
      });
      String temperatureString = "${weather.temperature.toString()}ºC";
    } catch (e) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(e.toString()),
      );
    }

  }


  void showErrorDialog(BuildContext context, Exception e) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
        );
      },
    );
  }

  // Aca segun si es día o noche, y la condicion meteorológica, te ayuda a elegir el outfit
  String _getSuggestedClothing({
    required double temperature,
    required String mainCondition,
  }) {
      if (mainCondition == 'clear') {
        if (temperature < 10) return "Mucho frio, campera abrigada";
        if (temperature < 17) return "Frio, pero soleado, campera abrigada";
        if (temperature < 25) return "Tiempo ideal, agarra un buzo liviano por las dudas";
        if (temperature < 30) return "Hace calor, ropa fresca.";
        if (temperature > 30) return "Bienvenido al infierno";
      }
      if (mainCondition == 'clouds'){
        if (temperature < 10) return "Mucho frio y nublado, abrigate mucho";
        if (temperature < 15) return "Está fresco y nublado, abrigate bien";
        if (temperature < 25) return "Está lindo pero nublado, llevá campera livana por las dudas";
        if (temperature < 30) return "Hace calor y seguro hay humedad, si no te tosquea lleva campera por las dudas";
        if (temperature > 30) return "Quedate abajo del aire salvo que sea obligatorio salir";
      }
      if (mainCondition == 'rain' || mainCondition == 'shower rain' || mainCondition == 'atmosphere' || mainCondition == 'thunder storm'){
        if (temperature < 5) return "Hace mucho frío y esta lloviendo o va a llover, abrigate una banda";
        if (temperature < 15) return "Está fresco y lloviendo, llevate una campera";
        if (temperature < 25) return "Llueve y hay humedad, llevá campera livana o paraguas";
        if (temperature < 30) return "Hace calor y hay humedad, F";
        if (temperature > 30) return "MEJOR MORIR QUE VIVIR ESTA HUMEDAD Y CALOR";
      }
    return "O está nevando o no cargan los datos, mira por la ventana por las dudas";
}

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        _isLoading = false;
      });
    });
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _weather == null
          ? _buildSplashScreen()
          : _buildWeatherContent(),
    );
  }

  Widget _buildSplashScreen() {
    return _isLoading
        ? Center(
      child: Lottie.asset('assets/hanger.json'),
    )
        : _buildWeatherContent();
  }

  Widget _buildWeatherContent() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_weather == null)
            const Center(
              child: CircularProgressIndicator(),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 24),
                child: Text(
                  _weather?.cityName ?? "Buscando tu ubicación",
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  if (_weather?.temperature != null)
                    Text(
                      '${_weather?.temperature.round()}ºC',
                      style: const TextStyle(fontSize: 40),
                    ),
                  const SizedBox(width: 10),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 35),
                child: Text(
                  _suggestedClothing,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              // Add SizedBox to create space
              const SizedBox(height: 50),
            ],
          ),
        ],
      ),
    );
  }
}
