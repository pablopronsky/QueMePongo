import 'dart:async';
import 'package:dev/pages/outfit_page.dart';
import 'package:dev/service/weather_service.dart';
import 'package:flutter/material.dart';
import '../model/weather_model.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => WeatherPageState();
}

class WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('bf60016fc2c512c3497f432fc12a01ae');
  Weather? _weather;
  bool _isLoading = true;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _isLoading = false; // Indica que la carga ha terminado
      });
    } catch (e) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(e.toString()),
      );
    }
  }

  // elije color para la temperatura segun el calor que hace
  Color _getColor(double temperature) {
    if (temperature < 15) return Colors.indigo;       // mucho frio   --> letra azul
    if (temperature < 25) return Colors.green;        // tiempo lindo --> letra verde
    if (temperature < 30) return Colors.amberAccent;  // calor        --> letra amarilla
    if (temperature > 30) {
      return Colors.redAccent;                        // mucho calor  --> letra roja
    } else {
      return Colors.black;                            // defaultea letras negras
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

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 4000), () {
      setState(() {
        _isLoading = false;
        _buildSplashScreen();
        _fetchWeather();
      });
    });
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
    if (_isLoading) {
      return SizedBox.expand(
        child: Lottie.asset(
          'assets/loading_screen.json',
          fit: BoxFit.contain,
        ),
      );
    } else {
      return _buildWeatherContent();
    }
  }

  Widget _buildWeatherContent() {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            '¿Qué me pongo?',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_weather == null)
              const Center(
                child: CircularProgressIndicator(),
              ),
            _buildWeatherDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCityName(),
        _buildTemperature(),
        _buildOutfitsButton(),
      ],
    );
  }

  Widget _buildCityName() {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.125,
        bottom: 44,
      ),
      child: Text(
        _weather?.cityName ?? "Buscando tu ubicación",
        style: TextStyle(
          fontSize: _weather?.cityName != null ? 70 : 25,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildTemperature() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 10),
        if (_weather?.temperature != null)
          Text(
            '${_weather?.temperature.round()}ºC',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: _getColor(_weather!.temperature),
            ),
          ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildOutfitsButton() {
    return Visibility(
      visible: _weather?.temperature != null,
      child: Container(
        margin: const EdgeInsets.only(top: 100),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            shape: const CircleBorder(),
            minimumSize: const Size(150, 150),
            padding: const EdgeInsets.all(20),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Outfit(_fetchWeather())),
          ),
          child: const Text(
            'Ver outfits',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
