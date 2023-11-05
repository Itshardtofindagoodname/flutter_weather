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
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Animate(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Your Personal Weather App.',
                  style: TextStyle(fontSize: 30, color: Colors.grey.shade700),
                ),
              ),
            ),
            Animate(
              effects: const [
                FadeEffect(delay: Duration(seconds: 1)),
              ],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Where you can search up the weather of any location in seconds.',
                  style: TextStyle(fontSize: 20, color: Colors.grey.shade500),
                ),
              ),
            ),
            Lottie.asset('assets/hamster.json'),
            const SizedBox(height: 50),
            isLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.grey.shade500,
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(70))
                : Animate(
                    effects: const [FadeEffect(delay: Duration(seconds: 1))],
                    child: GestureDetector(
                      onTap: () {
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
                      child: AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 200,
                        ),
                        height: 65,
                        width: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.grey[300],
                            shape: BoxShape.rectangle,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFFBEBEBE),
                                offset: Offset(10, 10),
                                blurRadius: 30,
                                spreadRadius: 1,
                              ),
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset(-10, -10),
                                blurRadius: 30,
                                spreadRadius: 1,
                              ),
                            ]),
                        child: Center(
                          child: Text(
                            'Let\'s get going',
                            style: TextStyle(
                                fontSize: 25, color: Colors.grey.shade700),
                          ),
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

mixin AnimateType {}
