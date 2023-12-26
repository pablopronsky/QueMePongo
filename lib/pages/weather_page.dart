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
  String _suggestedClothing = "";
  bool _isLoading = true;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _suggestedClothing = getSuggestedClothing(
          temperature: weather.temperature,
          mainCondition: weather.mainCondition.toLowerCase(),
        );
        _isLoading = false; // Indica que la carga ha terminado
      });
    } catch (e) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(e.toString()),
      );
    }
  }

  String getSuggestedClothing({
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
      appBar: AppBar(
        title: const Center(child: Text('¿Qué me pongo?',
        style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold),
          )
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: _weather == null
          ? _buildSplashScreen()
          : _buildWeatherContent(),
    );
  }

  Widget _buildSplashScreen() {
    if (_isLoading) {
      return Center(
        child: Lottie.asset('assets/hanger.json'),
    );
    } else {
      return _buildWeatherContent();
    }
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
          _buildWeatherDetails(),
        ],
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
        bottom: 24,
      ),
      child: Text(
        _weather?.cityName ?? "Buscando tu ubicación",
        style: TextStyle(
          fontSize: _weather?.cityName != null ? 50 : 25,
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
            style: const TextStyle(fontSize: 40),
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
