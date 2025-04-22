import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'feature_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    const WelcomeScreen(),
    const FeatureScreen(
      imagePath: 'assets/onboarding_1.png',
      title: 'INTERACTIVE EXPLANATION',
      description: 'This feature brings statues, artifacts, and history to life, allowing users to explore their history.',
    ),
    const FeatureScreen(
      imagePath: 'assets/onboarding_2.png',
      title: 'EXPLORE LANDMARKS',
      description: 'Through high-quality image and audio narration.',
    ),
    const FeatureScreen(
      imagePath: 'assets/onboarding_3.png',
      title: 'LANDMARK DETECTION',
      description: 'Scan and learn about landmarks that you are visiting.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: _pages,
          ),
          Positioned(
            bottom: 10,
            left: 30,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage != 0)
                  TextButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text(
                      'Back',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                else
                  const SizedBox(),
                Row(
                  children: List.generate(
                    _pages.length,
                        (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
                _currentPage == _pages.length - 1
                    ? ElevatedButton(
                  onPressed: () {
                    // Navigate to the LoginScreen
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  child: const Text('Get Started'),
                )
                    : TextButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}