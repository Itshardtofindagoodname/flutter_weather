// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:weathering_init/models/weathermodel.dart';
import 'package:weathering_init/services/weatherservice.dart';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

Future<bool> validateCity(String cityName) async {
  const apiKey = '0870e5f1c8551c21623372bc54983ab1';
  final url = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
    'q': cityName,
    'appid': apiKey,
  });

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('0870e5f1c8551c21623372bc54983ab1');
  Weather? _weather;
  final TextEditingController _cityController = TextEditingController();
  bool _showCityInput = true;

  _fetchWeather(BuildContext context) async {
    String cityName = _cityController.text;

    showLoadingDialog(context);

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _showCityInput = false;
      });
    } catch (e) {
      print(e);
    } finally {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: AlertDialog(
            backgroundColor: Colors.grey,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Fetching the weather for you..'),
                Lottie.asset('assets/flyer.json'),
              ],
            ),
          ),
        );
      },
    );
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/cloud.json';
      case 'mist':
        return 'assets/cloud.json';
      case 'smoke':
        return 'assets/cloud.json';
      case 'haze':
        return 'assets/fog.json';
      case 'dust':
        return 'assets/dust.json';
      case 'fog':
        return 'assets/fog.json';
      case 'rain':
        return 'assets/rain.json';
      case 'drizzle':
        return 'assets/rain.json';
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      case 'snow':
        return 'assets/snow.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'WEATHERING INIT',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.grey.shade700,
            ),
          ),
          automaticallyImplyLeading: false,
          shadowColor: Colors.black,
          backgroundColor: Colors.grey.shade300,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _showCityInput = true;
                });
              },
              color: Colors.grey.shade700,
            ),
          ],
        ),
        backgroundColor: Colors.grey.shade300,
        body: SafeArea(
            child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            _weatherpage(context),
          ]),
        )));
  }

  Container _weatherpage(BuildContext context) {
    return Container(
      height: 400,
      width: 350,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.shade300,
          boxShadow: [
            const BoxShadow(
                offset: Offset(10, 10), color: Colors.black38, blurRadius: 20),
            BoxShadow(
                offset: const Offset(-10, -10),
                color: Colors.white.withOpacity(0.85),
                blurRadius: 20)
          ]),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_showCityInput)
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: _input(context),
              ),
            if (!_showCityInput && _weather != null)
              Animate(
                effects: const [FadeEffect(delay: Duration(seconds: 2))],
                child: Column(
                  children: [
                    Text(
                      _weather?.cityName ?? "",
                      style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(' ${_weather?.temperature.roundToDouble() ?? ""}°C',
                        style:
                            const TextStyle(fontSize: 30, color: Colors.black)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      _weather?.mainCondition ?? "",
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _cityInputError = '';
  bool _isElevated = false;
  BackdropFilter _input(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Container(
        height: 350,
        width: 250,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey.shade300,
            boxShadow: [
              const BoxShadow(
                  offset: Offset(10, 10),
                  color: Colors.black38,
                  blurRadius: 20),
              BoxShadow(
                  offset: const Offset(-10, -10),
                  color: Colors.white.withOpacity(0.85),
                  blurRadius: 20)
            ]),
        child: Column(
          children: [
            Text(
              'Enter your desired Location:',
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 32,
            ),
            Material(
              shadowColor: Colors.grey,
              borderRadius: BorderRadius.circular(10),
              child: TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'City Name',
                  border: const OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintStyle: TextStyle(color: Colors.grey.shade700),
                ),
                style: const TextStyle(
                  color: Colors.black,
                ),
                cursorColor: Colors.grey.shade400,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              _cityInputError,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 60),
            Animate(
              effects: const [FlipEffect(delay: Duration(seconds: 2))],
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    _isElevated = !_isElevated;
                  });
                  final cityName = _cityController.text;
                  if (cityName.isEmpty) {
                    setState(() {
                      _cityInputError = 'City Name cannot be a Blank Space';
                    });
                  } else {
                    setState(() {
                      _cityInputError = '';
                    });
                    final isValidCity = await validateCity(cityName);
                    if (isValidCity) {
                      _fetchWeather(context);
                    } else {
                      setState(() {
                        _cityInputError =
                            'Couldn\'t find that location, please check the spelling or try another city.';
                      });
                    }
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 200,
                  ),
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.grey.shade300,
                    shape: BoxShape.rectangle,
                    boxShadow: _isElevated
                        ? [
                            const BoxShadow(
                              color: Color(0xFFBEBEBE),
                              offset: Offset(10, 10),
                              blurRadius: 30,
                              spreadRadius: 1,
                            ),
                            const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-10, -10),
                              blurRadius: 30,
                              spreadRadius: 1,
                            ),
                          ]
                        :
                        // Depth Effect
                        [
                            const BoxShadow(
                              color: Color(0xFFBEBEBE),
                              offset: Offset(10, 10),
                              blurRadius: 10,
                              spreadRadius: -2,
                            ),
                            const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-10, -10),
                              blurRadius: 10,
                              spreadRadius: -2,
                            ),
                          ],
                  ),
                  child: Icon(
                    Icons.search_rounded,
                    size: 40,
                    color: _isElevated ? Colors.black45 : Colors.black26,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
