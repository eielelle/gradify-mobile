import 'package:flutter/material.dart';
import 'package:gradify/config/themes/theme_manager.dart';
import 'package:gradify/views/layouts/application_layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
      theme: ThemeManager.lightTheme,
      home: const ApplicationLayout(),
    ));
}
