import 'package:flutter/material.dart';
import 'package:grammar_check_app/my_app.dart';

class OnboardingScreen2 extends StatefulWidget {
  final String mUrl;
  final String text1;
  final String text2;
  final String text3;
  final String bg;

  const OnboardingScreen2({
    super.key,
    required this.mUrl,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.bg,
  });

  @override
  _OnboardingScreen2State createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  TextStyle mTextStyle = TextStyle(
      color: const Color.fromARGB(255, 213, 87, 235),
      fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.network(
              widget.bg,
              fit: BoxFit.cover,
            ),
          ),
          Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: <Widget>[
                  OnboardingPage(
                    title: "Welcome",
                    body: widget.text1,
                    image: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Image.asset(
                        "assets/icon.png",
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),
                  OnboardingPage(
                    title: "Stay Connected",
                    body: widget.text2,
                    image: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Image.asset(
                        "assets/icon.png",
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),
                  OnboardingPage(
                    title: "Get Started",
                    body: widget.text3,
                    image: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Image.asset(
                        "assets/icon.png",
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentPage != 2)
                      InkWell(
                        onTap: () {
                          _pageController.jumpToPage(2);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text("Skip", style: mTextStyle),
                        ),
                      )
                    else
                      InkWell(
                        onTap: null,
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text("         ", style: mTextStyle),
                        ),
                      ),
                    Row(
                      children: List.generate(
                        3,
                        (index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Color.fromARGB(255, 213, 87, 235)
                                : Color.fromARGB(255, 213, 87, 235)
                                    .withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (_currentPage == 2) {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (_) => MyAppSecPage(mUrl: widget.mUrl),
                          ));
                        } else {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          _currentPage == 2 ? "Done" : "Next",
                          style: mTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String body;
  final Widget image;

  OnboardingPage(
      {required this.title, required this.body, required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image,
          SizedBox(height: 40),
          Text(
            title,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            body,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
