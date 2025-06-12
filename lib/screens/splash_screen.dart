import 'dart:async';

import 'package:chatbot/constants/app_colors.dart';
import 'package:chatbot/constants/app_images.dart';
import 'package:chatbot/screens/chat_screen.dart';
import 'package:chatbot/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key}); // Made constructor const

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      final box = GetStorage();

      final bool? isOnBoardingPlayed = box.read('isOnBoardingPlayed');
      if (isOnBoardingPlayed == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );
      }
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
          AppImages.splashImage,
          height: height * 0.6,
          width: width * 0.6,
        ),
      ),
    );
  }
}
