import 'package:flutter/material.dart';
import 'package:gradify/screens/sign_in.dart';

class ApplicationLayout extends StatelessWidget {
  const ApplicationLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: SignInScreen()),
    );
  }
}
