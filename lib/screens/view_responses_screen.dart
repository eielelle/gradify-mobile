import 'package:flutter/material.dart';

class ViewResponsesScreen extends StatefulWidget {
  const ViewResponsesScreen({super.key});

  @override
  State<ViewResponsesScreen> createState() => _ViewResponsesScreenState();
}

class _ViewResponsesScreenState extends State<ViewResponsesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(101, 188, 80, 1),
        title: const Text("View Responses"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
