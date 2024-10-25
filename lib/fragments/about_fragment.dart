import 'package:flutter/material.dart';

class AboutFragment extends StatelessWidget {
  const AboutFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "About You",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            _buildCard('My Account', 'Email, Name, etc.'),
            const SizedBox(height: 14),
            _buildCard('About', 'About the app'),
            const SizedBox(height: 14),
            _buildCard('Sign Out', 'Sign out from the current session'),
            const SizedBox(height: 14),
          ],
        ));
  }

  Widget _buildCard(String title, String subtitle) {
    return Card(
      color: const Color.fromRGBO(41, 46, 50, 1),
      elevation: 4,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        subtitle: Text(subtitle,
            style: const TextStyle(color: Color.fromRGBO(187, 187, 187, 1))),
      ),
    );
  }
}
