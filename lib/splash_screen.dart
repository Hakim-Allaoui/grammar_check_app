import 'package:flutter/material.dart';
import 'package:grammar_check_app/main.dart';
import 'package:grammar_check_app/onboarding_screen.dart';
import 'package:grammar_check_app/tools.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

String iconUrl = "";

class _SplashScreenState extends State<SplashScreen> {
  Map<String, dynamic> config = {};

  @override
  void initState() {
    super.initState();
    _checkSecondDashboard();
  }

  Future<void> _checkSecondDashboard() async {
    try {
      config = await fetchConfig();

      bool value = true;
      //config["value"];
      String mUrl = config["url"];
      String icon = config["icon"];
      String bg = config["bg"];
      String text1 = config["text1"];
      String text2 = config["text2"];
      String text3 = config["text3"];

      iconUrl = icon;

      if (value) {
        // Navigate to the second screen
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (_) => OnboardingScreen(
        //       mUrl: mUrl,
        //       text1: text1,
        //       text2: text2,
        //       text3: text3,
        //     ),
        //   ),
        // );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => OnboardingScreen2(
              mUrl: mUrl,
              text1: text1,
              text2: text2,
              text3: text3,
              bg: bg,
            ),
          ),
        );
      } else {
        // Navigate to the home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      }
    } catch (e) {
      // Handle any errors here, e.g., show a dialog or a retry option
      print("Error checking document: $e");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
