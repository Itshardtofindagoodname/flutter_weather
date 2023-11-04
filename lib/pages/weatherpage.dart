// ignore_for_file: use_build_context_synchronously, avoid_print

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
        return AlertDialog(
          backgroundColor: Colors.grey,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Fetching the weather for you..'),
              Lottie.asset('assets/flyer.json'),
            ],
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
          title: const Text(
            'WEATHERING INIT',
            style: TextStyle(color: Colors.black),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _showCityInput = true;
                });
              },
              color: Colors.black,
            ),
          ],
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            _weatherpage(context),
          ]),
        )));
  }

  Column _weatherpage(BuildContext context) {
    return Column(
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
                      color: Colors.white),
                ),
                Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                const SizedBox(
                  height: 10,
                ),
                Text(' ${_weather?.temperature.roundToDouble() ?? ""}°C',
                    style: const TextStyle(fontSize: 30, color: Colors.white)),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  _weather?.mainCondition ?? "",
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                )
              ],
            ),
          ),
      ],
    );
  }

  String _cityInputError = '';

  Column _input(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Enter your desired Location:',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(
          height: 32,
        ),
        TextField(
          controller: _cityController,
          decoration: const InputDecoration(
            labelText: 'City Name',
            border: OutlineInputBorder(),
            labelStyle: TextStyle(color: Colors.white),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: const TextStyle(
            color: Colors.white,
          ),
          cursorColor: Colors.white,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          _cityInputError,
          style: const TextStyle(color: Colors.red),
        ),
        const SizedBox(height: 40),
        Animate(
          effects: const [FlipEffect(delay: Duration(seconds: 2))],
          child: OutlinedButton(
            onPressed: () async {
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
            style: ButtonStyle(
              side: MaterialStateProperty.resolveWith(
                (states) {
                  if (states.contains(MaterialState.disabled)) {
                    return const BorderSide(color: Colors.black);
                  }
                  return const BorderSide(color: Colors.black);
                },
              ),
              foregroundColor: MaterialStateProperty.resolveWith(
                (states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.black;
                  }
                  return Colors.black;
                },
              ),
              backgroundColor: MaterialStateProperty.resolveWith(
                (states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.white;
                  }
                  return Colors.white;
                },
              ),
            ),
            child: const Text(
              'Get Weather',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        )
      ],
    );
  }
}
