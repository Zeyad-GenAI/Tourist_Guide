import 'package:flutter/material.dart';
import 'package:museum/register_screen.dart';
import 'package:museum/statue_screens.dart';
import 'package:museum/forgot_password_screen.dart';
import 'package:museum/login_screen.dart';
import 'package:museum/onboarding_screens.dart';

import 'home.dart';


void main() {
  runApp(const EgyLensApp());
}

class EgyLensApp extends StatelessWidget {
  const EgyLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EGY Lens',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/statue_screens': (context) => MainBottomNavigation(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        HomePage.routeName: (context) => const HomePage(),
        '/chat': (context) => const ChatPage(),
      },
    );
  }
}