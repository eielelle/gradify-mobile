import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutFragment extends StatefulWidget {
  const AboutFragment({super.key});

  @override
  State<AboutFragment> createState() => _AboutFragmentState();
}

class _AboutFragmentState extends State<AboutFragment> {
  String name = "";
  String email = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setAbout();
  }

  Future<void> setAbout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('auth_name') ?? "";
      email = prefs.getString('auth_email') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(12),
        child: Column(
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
                    Text("Name: $name", style: TextStyle(color: Colors.white)),
                    Text("Email: $email",
                        style: TextStyle(color: Colors.white)),
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
