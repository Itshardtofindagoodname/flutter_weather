// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Import the flutter_animate package
import 'WeatherPage.dart';

class onBoard extends StatefulWidget {
  const onBoard({Key? key}) : super(key: key);

  @override
  _onBoardState createState() => _onBoardState();
}

class _onBoardState extends State<onBoard> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Animate(
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Your Personal Weather App.',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
            Animate(
              effects: const [
                FadeEffect(delay: Duration(seconds: 1)),
              ],
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Where you can search up the weather of any location in seconds.',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ),
            ),
            Animate(
              effects: const [BlurEffect(delay: Duration(seconds: 10))],
              child: Lottie.asset('assets/hamster.json'),
            ),
            const SizedBox(height: 50),
            isLoading
                ? const CircularProgressIndicator()
                : Animate(
                    effects: const [FadeEffect(delay: Duration(seconds: 1))],
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.all(16.0),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });

                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WeatherPage(),
                            ),
                          );
                        });
                      },
                      child: const Text(
                        'Click here to get started',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

mixin AnimateType {}
