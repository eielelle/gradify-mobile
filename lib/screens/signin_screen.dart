import 'package:flutter/material.dart';
import 'package:scannerv3/screens/home_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(50, 57, 62, 1),
      body: Column(
        children: [
          Expanded(
              child: Center(
            child: Image.asset('assets/images/logo.png'),
          )),
          Container(
              color: const Color.fromRGBO(41, 46, 50, 1),
              padding: const EdgeInsets.fromLTRB(14, 32, 14, 18),
              child: Column(
                children: [
                  const Text("Sign In",
                      style: TextStyle(fontSize: 24, color: Colors.white)),
                  const Text("Sign in to continue using the app",
                      style:
                          TextStyle(color: Color.fromRGBO(187, 187, 187, 1))),
                  const SizedBox(height: 20),
                  const TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintStyle:
                            TextStyle(color: Color.fromRGBO(187, 187, 187, 1)),
                        hintText: "Email",
                        fillColor: Color.fromRGBO(50, 57, 62, 1),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.green), // Border when enabled
                        ),
                        filled: true),
                  ),
                  const SizedBox(height: 14),
                  const TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintStyle:
                            TextStyle(color: Color.fromRGBO(187, 187, 187, 1)),
                        hintText: "Password",
                        fillColor: Color.fromRGBO(50, 57, 62, 1),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.green), // Border when enabled
                        ),
                        filled: true),
                    obscureText: true,
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()),
                                (route) => false);
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
                            "SIGN IN",
                            style: TextStyle(color: Colors.white),
                          )))
                ],
              ))
        ],
      ),
    );
  }
}
