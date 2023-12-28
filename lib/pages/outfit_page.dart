import 'package:flutter/foundation.dart';
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
    mainCondition.toLowerCase();

    switch (mainCondition) {
      case 'clear':
        if (temperature < 10) {
          return 'Mucho frío, campera abrigada';
        } else if (temperature < 17) {
          return 'Frío, pero soleado, campera abrigada';
        } else if (temperature < 25) {
          return 'Tiempo ideal, agarra un buzo liviano por las dudas';
        } else if (temperature < 30) {
          return 'Hace calor, ropa fresca.';
        } else {
          return 'Bienvenido al infierno';
        }
      case 'clouds':
        if (temperature < 10) {
          return 'Mucho frío y nublado, abrigate mucho';
        } else if (temperature < 15) {
          return 'Está fresco y nublado, abrigate bien';
        } else if (temperature < 25) {
          return 'Está lindo pero nublado, llevá campera livana por las dudas';
        } else if (temperature < 30) {
          return 'Hace calor y seguro hay humedad, si no te tosquea lleva campera por las dudas';
        } else {
          return 'Quedate abajo del aire salvo que sea obligatorio salir';
        }
      case 'rain':
      case 'shower rain':
      case 'atmosphere':
      case 'thunder storm':
        if (temperature < 5) {
          return 'Hace mucho frío y esta lloviendo o va a llover, abrigate una banda';
        } else if (temperature < 15) {
          return 'Está fresco y lloviendo, llevate una campera';
        } else if (temperature < 25) {
          return 'Llueve y hay humedad, llevá campera livana o paraguas';
        } else if (temperature < 30) {
          return 'Hace calor y hay humedad, F';
        } else {
          return 'MEJOR MORIR QUE VIVIR ESTA HUMEDAD Y CALOR';
        }
      case 'snow':
        if (temperature < 0) {
          return 'Hace mucho frío y esta nevando, abrigate de cabeza a pies';
        } else {
          return 'Está nevando, llevá ropa abrigada y calzado adecuado';
        }
      case 'mist':
        return 'Está brumoso, llevá un abrigo ligero y un paraguas';
      case 'haze':
        return 'Está nublado y con neblina, llevá un abrigo ligero y un paraguas';
      case 'dust':
        return 'Hay polvo en el aire, usa barbijo';
      case 'sand':
        return 'Hay arena en el aire, llevá una mascarilla o pañuelo';
      case 'fog':
        return 'Hay niebla, llevá un abrigo ligero y un paraguas';
      default:
        return 'O está nevando o no cargan los datos, mira por la ventana por las dudas';
    }
  }

  String _getAnimacion(String mainCondition) {
    switch (mainCondition) {
      case 'clear':
        return 'assets/soleado.json';
      case 'clouds':
        return 'assets/nublado.json';
      case 'rain':
      case 'shower rain':
      case 'atmosphere':
        return 'lluvia.json';
      case 'thunder storm':
        return 'assets/tormenta_electrica.json';
      default:
        return 'assets/soleado.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    _fetchWeather();

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        '¿Qué me pongo?',
        style: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.deepPurple,
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: _buildWeatherAnimation(),
        ),
        Expanded(
          child: _buildWeatherInfo(),
        ),
      ],
    );
  }

  Widget _buildWeatherAnimation() {
    if (_weather == null) {
      // Manejar el caso en que _weather es nulo
      return const Center(
        child: Text(
          'Cargando datos del tiempo',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.deepPurple),
        ),
      );
    }
    String mainCondition = _weather?.mainCondition?.toLowerCase() ?? 'clear';
    String animationAsset = _getAnimacion(mainCondition);
    try {
      return Lottie.asset(
        animationAsset,
        animate: true,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error al cargar la animación: $e');
      }
      return const Center(
        child: Text(
          'Error al cargar la animación',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.red),
        ),
      );
    }
  }

  Widget _buildWeatherInfo() {
    return Column(
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
              style: const TextStyle(fontSize: 24, color: Colors.deepPurple, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}

