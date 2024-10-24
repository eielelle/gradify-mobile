import 'package:flutter/material.dart';
import 'package:scannerv3/screens/signin_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(50, 57, 62, 1),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
          Container(
              color: const Color.fromRGBO(41, 46, 50, 1),
              padding: const EdgeInsets.fromLTRB(14, 32, 14, 18),
              child: Column(
                children: [
                  const Text(
                    "Welcome to Gradify",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  const Text(
                    "Scan Fast, Score Smart: Get Results Quickly with Gradify - Your Exam Buddy!",
                    style: TextStyle(color: Color.fromRGBO(187, 187, 187, 1)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SigninScreen()), (route) => false);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(101, 188, 80, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Set border radius
                            ),
                          ),
                          child: const Text(
                            "Get Started",
                            style: TextStyle(color: Colors.white),
                          )))
                ],
              ))
        ],
      ),
    );
  }
}
