import 'package:flutter/material.dart';
import 'package:gradify/config/themes/theme_manager.dart';
import 'package:gradify/screens/sign_in.dart';
import 'package:gradify/views/layouts/application_layout.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ProviderScope(
    child: MaterialApp(
      theme: ThemeManager.lightTheme,
      home: const ApplicationLayout(
        child: SignInScreen(),
      ),
    ),
  ));
}
