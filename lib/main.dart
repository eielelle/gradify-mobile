import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scannerv3/screens/home_screen.dart';
import 'package:scannerv3/screens/welcome_screen.dart';
import 'package:scannerv3/utils/token_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> isLoggedIn() async {
    String? token = await TokenManager().getAuthToken();

    return token != null;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: isLoggedIn(),
        builder: (context, snapshot) {
          // While the future is loading, show a loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // If an error occurred
          if (snapshot.hasError) {
            exit(0);
          }
          // If the future completed successfully
          if (snapshot.hasData) {
            return snapshot.data! ? const HomeScreen() : const WelcomeScreen();
          }
          // Fallback in case of unexpected state
          exit(0);
        },
      ),
    );
  }
}
