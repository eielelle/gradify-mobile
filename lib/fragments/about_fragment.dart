import 'package:flutter/material.dart';

class AboutFragment extends StatelessWidget {
  const AboutFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About You",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 14),
            _buildCard('My Account', 'Email, Name, etc.'),
            SizedBox(height: 14),
            _buildCard('About', 'About the app'),
            SizedBox(height: 14),
            _buildCard('Sign Out', 'Sign out from the current session'),
            SizedBox(height: 14),
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
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        subtitle: Text(subtitle,
            style: TextStyle(color: Color.fromRGBO(187, 187, 187, 1))),
      ),
    );
  }
}
