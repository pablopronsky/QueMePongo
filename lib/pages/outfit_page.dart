import 'package:flutter/material.dart';
import 'package:dev/pages/weather_page.dart';
import 'package:dev/service/weather_service.dart';

import '../model/weather_model.dart';

class Outfit extends StatefulWidget {
  const Outfit(fetchWeather, {super.key});

  @override
  State<Outfit> createState() => _OutfitState();
}

class _OutfitState extends State<Outfit> {
  WeatherPageState weatherPageState = WeatherPageState();

  final _weatherService = WeatherService('bf60016fc2c512c3497f432fc12a01ae');

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
    return Container(
      color: Colors.white, // Set background color to white
      child: const Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 35),
          child: Text(
            'Aca van los outfit',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

