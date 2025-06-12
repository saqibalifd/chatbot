import 'package:chatbot/constants/app_colors.dart';
import 'package:chatbot/constants/app_images.dart';
import 'package:chatbot/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Youre AI Assistant',
                style: GoogleFonts.nunito(
                  color: AppColors.blue,
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: height * 0.02),
              Text(
                'Using this software,you can ask you\nquestions and receive articles using\nartificial intelligence assistant',
                style: GoogleFonts.nunito(
                  color: AppColors.greyColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              Image.asset(
                AppImages.onBoardingImage,
                width: width * 0.8,
                height: height * 0.6,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                child: InkWell(
                  onTap: () {
                    final box = GetStorage();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen()),
                    );
                    final bool value = true;
                    box.write('isOnBoardingPlayed', value);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(height * 0.1),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: width * .05),
                            Text(
                              'Continue',
                              style: GoogleFonts.nunito(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.arrow_circle_right,
                                  color: AppColors.primaryColor,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
