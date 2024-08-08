import 'package:flutter/material.dart';

class AppRouter {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Navigate to a specific page
  Future<void> navigateTo(Widget page) async {
    if (navigatorKey.currentState != null) {
      await navigatorKey.currentState!.push(
        MaterialPageRoute(builder: (context) => page),
      );
    }
  }

  // Navigate to a specific page and remove all previous pages
  Future<void> navigateAndRemoveUntil(Widget page) async {
    if (navigatorKey.currentState != null) {
      await navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => page),
        (route) => false,
      );
    }
  }

  // Go back to the previous page
  void goBack() {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.pop();
    }
  }
}
