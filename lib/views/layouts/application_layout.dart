import 'package:flutter/material.dart';
import 'package:gradify/config/values/sizes.dart';

class ApplicationLayout extends StatelessWidget {
  final Widget child;

  const ApplicationLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(AppSizes.mediumPadding),
        child: child,
      )),
    );
  }
}
