import 'package:flutter/material.dart';

class AboutFragment extends StatelessWidget {
  const AboutFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(12),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 14),
            Card(
              color: const Color.fromRGBO(41, 46, 50, 1),
              elevation: 4,
              child: ListTile(
                title: Text(
                  "My Account",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),
                    Text("Name: ", style: TextStyle(color: Colors.white)),
                    Text("Email: ", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            )
            // _buildCard('About', 'About the app'),
            // const SizedBox(height: 14)
          ],
        ));
  }
}
