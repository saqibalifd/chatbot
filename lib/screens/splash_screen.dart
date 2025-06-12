// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:async';

import 'package:chatbot/constants/app_colors.dart';
import 'package:chatbot/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      backgroundColor: AppColors.blue,
      body: Center(
        child: Image.asset(
          'assets/images/splashscreen.png',
          height: height * 0.6,
          width: width * 0.6,
        ),
      ),
    );
  }
}
