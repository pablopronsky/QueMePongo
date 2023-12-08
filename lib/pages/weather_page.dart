import 'package:dev/service/weather_service.dart';
import 'package:flutter/foundation.dart';
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
  String _suggestedClothing = "";

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _suggestedClothing = _getSuggestedClothing(
          temperature: weather.temperature,
          mainCondition: weather.mainCondition.toLowerCase(),
          timeOfDay: _getTimeOfDay(),
        );
      });
    } catch (e) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(e.toString()),
      );
    }
  }

  String _getTimeOfDay() {
    // Aca se estima si es de día o de noche
    if (DateTime.now().hour >= 6 && DateTime.now().hour < 20) {
      return "dia";
    } else {
      return "noche";
    }
  }

  // Aca segun si es día o noche, y la condicion meteorológica, te ayuda a elegir el outfit
  String _getSuggestedClothing({
    required double temperature,
    required String mainCondition,
    required String timeOfDay,
  }) {
    if (timeOfDay == "dia") {
      if (mainCondition == 'clear') {
        if (temperature < 5) return "Hace mucho frío pero hay solcito";
        if (temperature < 15) return "Está fresco pero hay solcito";
        if (temperature < 25) return "Está hermoso, llevá campera por las dudas";
        if (temperature < 30) return "Hace calor, poca ropa y solo si no tosquea lleva camperita suelta";
        if (temperature > 30) return "Malla y toalla perro hace tremendo lorca";
      }
      if (mainCondition == 'clouds'){
        if (temperature < 5) return "Hace maximo frío y esta nublado, abrigate una banda";
        if (temperature < 15) return "Está fresco y nublado, llevate un abrigo";
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
    }
    else {
      if (mainCondition == 'clear') {
        if (temperature < 5) return "TE CONGELAS";
        if (temperature < 15) return "Hay un tornillo barbaro, full abrigo";
        if (temperature < 25) return "Está hermoso, llevá campera por las dudas";
        if (temperature < 30) return "Hace calor, poca ropa y solo si no tosquea lleva camperita suelta";
        if (temperature > 30) return "Abajo del aire";
      }
      if (mainCondition == 'clouds'){
        if (temperature < 5) return "Hace mucho frío y capaz hay viento, abrigate una banda";
        if (temperature < 15) return "Llevate un abrigo, si puede ser anti lluvia mejor";
        if (temperature < 25) return "Está lindo, llevá campera livana por las dudas";
        if (temperature < 30) return "Hace calor y seguro hay humedad, usa ropa comoda y fresca";
        if (temperature > 30) return "Quedate abajo del aire salvo que sea obligatorio salir"  ;
      }
      if (mainCondition == 'rain' || mainCondition == 'shower rain' || mainCondition == 'atmosphere' ||
          mainCondition == 'thunder storm'){
        if (temperature < 5) return "Hace mucho frío y esta lloviendo o va a llover, abrigate una banda";
        if (temperature < 15) return "Está fresco y lloviendo, llevate una campera";
        if (temperature < 25) return "Llueve y hay humedad, llevá campera de verano o paraguas";
        if (temperature < 30) return "Hace calor y hay humedad, está infumable";
        if (temperature > 30) return "MEJOR MORIR QUE VIVIR ESTA HUMEDAD Y CALOR";
      }
    }
    return "O está nevando o no cargan los datos, mira por la ventana por las dudas";
}

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center, // Center everything when loading
          children: [
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
                if (_weather?.mainCondition != null)
                  //Lottie.asset(getWeatherAnimation(_weather?.mainCondition)), // Show animation only if data is available
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Text(
                    '${_weather?.temperature != null ? _weather?.temperature.round() : '...'}ºC',
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 35),
                  child: Text(
                    _suggestedClothing,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            if (_weather == null)
              const Center( // Show loading indicator only when data is not available
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
