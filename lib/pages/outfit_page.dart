import 'package:flutter/material.dart';
import 'package:dev/pages/weather_page.dart';
import 'package:lottie/lottie.dart';

class Outfit extends StatefulWidget {
  const Outfit(fetchWeather, {super.key});

  @override
  State<Outfit> createState() => _OutfitState();
}

class _OutfitState extends State<Outfit> {



  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Set background color to white
      child: Center(child: Lottie.asset('assets/shirt.json')),
    );
  }
}

