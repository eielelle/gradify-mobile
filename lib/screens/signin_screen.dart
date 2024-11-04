import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scannerv3/screens/home_screen.dart';
import 'package:scannerv3/utils/token_manager.dart';
import 'package:scannerv3/values/api_endpoints.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = "";
  bool _loading = false;
  final Dio _dio = Dio();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> signin() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    setState(() {
      _loading = true;
    });

    try {
      final res = await _dio.post(ApiEndpoints.signIn, data: {
        "user": {"email": email, "password": password}
      });

      if (res.statusCode == 200) {
        final token = res.headers.value('Authorization');
        await TokenManager().saveToken(token);

        if (mounted) {
          setState(() {
            _errorMessage = "";
            _loading = false;
          });

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false);
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = "Invalid Email or Password";
            _loading = false;
          });

          _showErrorDialog(_errorMessage);
        }
      }
    } on DioException catch (error) {
      if (mounted) {
        // Handle errors from Dio
        setState(() {
          if (error.response!.headers['content-type']!
              .contains("application/json")) {
            _errorMessage =
                error.response?.data['status']['message'] ?? 'Error signing in';
          }
          _loading = false;
        });

        _errorMessage =
            "Can't log you in. Please check your internet connection.";
        _showErrorDialog(_errorMessage);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Authentication Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

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
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: _emailController,
                    decoration: const InputDecoration(
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
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: _passwordController,
                    decoration: const InputDecoration(
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
                            signin();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(101, 188, 80, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Set border radius
                            ),
                          ),
                          child: _loading
                              ? CircularProgressIndicator()
                              : const Text(
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
