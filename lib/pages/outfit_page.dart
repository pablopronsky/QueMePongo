import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../model/weather_model.dart';
import '../service/weather_service.dart';

class Outfit extends StatefulWidget {
  const Outfit(fetchWeather, {super.key});

  @override
  State<Outfit> createState() => _OutfitState();

}

class _OutfitState extends State<Outfit> {
  final _weatherService = WeatherService('bf60016fc2c512c3497f432fc12a01ae');
  Weather? _weather;
  String _suggestedClothing = "";

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
    });
  } catch (e) {
    return AlertDialog(
    title: const Text('Error'),
    content: Text(e.toString()),
    );}
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

  @override
  Widget build(BuildContext context) {
    _fetchWeather();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '¿Qué me pongo?',
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_weather == null)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  Center(
                    child: Text(
                      _suggestedClothing,
                      style: const TextStyle(fontSize: 24, color: Colors.deepPurple),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child:
            Lottie.asset(
              'assets/shirt.json',
              animate: true,
            ),
          ),
        ],
      ),
    );
  }
}

