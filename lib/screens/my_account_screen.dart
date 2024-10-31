import 'package:flutter/material.dart';
import 'package:scannerv3/widgets/custom_app_bar_widget.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget() as AppBar,
      body: Column(children: []),
    );
  }
}
