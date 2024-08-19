import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gradify/config/themes/theme.dart';
import 'package:gradify/config/values/sizes.dart';
import 'package:gradify/screens/fragments/about.dart';
import 'package:gradify/screens/fragments/class.dart';
import 'package:gradify/screens/fragments/exam.dart';
import 'package:gradify/screens/fragments/student.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = [
      const ExamFragment(),
      const ClassFragment(),
      const StudentFragment(),
      const AboutFragment()
    ];
    final selectedIndex = useState(0);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColorsLight.neutral,
          leading: const Center(
              child: Text(
            'Exam',
            style: TextStyle(
                fontSize: AppSizes.mediumFontSize,
                color: AppColorsLight.neutralContent),
          ))),
      body: widgetOptions.elementAt(selectedIndex.value),
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: AppColorsLight.baseContent,
          selectedItemColor: AppColorsLight.primary,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Iconsax.document),
              label: 'Exam',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.people),
              label: 'Class',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.profile_2user),
              label: 'Student',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.information),
              label: 'About',
            )
          ],
          currentIndex: selectedIndex.value,
          onTap: (index) => selectedIndex.value = index),
    );
  }
}
