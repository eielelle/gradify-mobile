import 'package:flutter/material.dart';
import 'package:gradify/pages/sign_in.dart';
import 'package:gradify/themes/theme_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
      theme: ThemeManager.lightTheme,
      home: const Scaffold(
        body: SafeArea(child: SignInPage()),
      ),
    ));
}
