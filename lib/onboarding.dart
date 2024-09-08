import 'package:flutter/material.dart';
import 'package:grammar_check_app/my_app.dart';
import 'package:grammar_check_app/splash_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final String mUrl;
  final String text1;
  final String text2;
  final String text3;

  const OnboardingScreen({
    super.key,
    required this.mUrl,
    required this.text1,
    required this.text2,
    required this.text3,
  });

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(
    initialPage: 0,
  );
  int _currentPage = 0;

  TextStyle mTextStyle = TextStyle(
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "Welcome",
            body: widget.text1,
            image: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image.asset(
                iconUrl,
                width: 150,
                height: 150,
              ),
            ),
          ),
          PageViewModel(
            title: "Stay Connected",
            body: widget.text2,
            image: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image.asset(
                iconUrl,
                width: 150,
                height: 150,
              ),
            ),
          ),
          PageViewModel(
            title: "Your Journey Starts Here",
            body: widget.text3,
            image: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image.asset(
                iconUrl,
                width: 150,
                height: 150,
              ),
            ),
          ),
        ],
        onDone: () {
          // When done button is pressed
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => MyAppSecPage(mUrl: widget.mUrl),
          ));
        },
        onSkip: () {
          // You can also skip the onboarding
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => MyAppSecPage(mUrl: widget.mUrl),
          ));
        },
        showSkipButton: true,
        skip: const Text("Skip"),
        next: const Icon(Icons.arrow_forward),
        done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
