import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(leading: Row(
      children: [
        Image.asset('assets/images/logo.png'),
        Text("Gradify")
      ],
    ),);
  }
}