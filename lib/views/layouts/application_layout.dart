import 'package:flutter/material.dart';

class ApplicationLayout extends StatelessWidget {
  final Widget child;

  const ApplicationLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: child),
    );
  }
}
