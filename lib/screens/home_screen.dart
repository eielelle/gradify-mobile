import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:scannerv3/fragments/about_fragment.dart';
import 'package:scannerv3/fragments/classes_fragment.dart';
import 'package:scannerv3/fragments/exams_fragment.dart';
import 'package:scannerv3/fragments/grade_fragment.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const ExamsFragment(),
    const ClassesFragment(),
    const GradeFragment(),
    const AboutFragment()
  ];

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(41, 46, 50, 1),
      appBar: AppBar(title: const Text("TEST")),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromRGBO(101, 188, 80, 1),
        fixedColor: Colors.white,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        onTap: onTappedBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.document), label: "Exams"),
          BottomNavigationBarItem(icon: Icon(Iconsax.people), label: "Classes"),
          BottomNavigationBarItem(icon: Icon(Iconsax.graph), label: "Grades"),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.profile_circle), label: "About"),
        ],
      ),
    );
  }
}
