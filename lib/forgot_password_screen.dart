import 'package:flutter/material.dart';
import 'chat.dart';
import 'widgets.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Forgot Password',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your email account to reset your password.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              const CustomTextField(
                hintText: 'example@example.com',
                prefixIcon: Icons.email,
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Reset Password',
                onPressed: () {
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}