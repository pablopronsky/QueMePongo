import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../model/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService{
  static const String URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(Uri.parse('$URL?q=$cityName&lang=sp&appid=$apiKey&units=metric'));
    if (response.statusCode != 200) {
      throw Exception('Error al obtener el clima: ${response.statusCode}');
    }
    if(response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error');
    }
  }

  Future <String> getCurrentCity() async {
    // busca permisos para acceder a la ubicación
    LocationPermission locationPermission = await Geolocator.checkPermission();
    // si no los consigue, vuelve a intentar
    if(locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.checkPermission();
    }
    // accede a la ubicación del usuario
    Position userPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    // coordenadas
    List<Placemark> placemarks = await placemarkFromCoordinates(userPosition.latitude, userPosition.longitude);
    // a traves de las placemarks de arriba consigue el nombre de la localidad
    String? city = placemarks[0].locality;
    return city ?? "";
  }
}
