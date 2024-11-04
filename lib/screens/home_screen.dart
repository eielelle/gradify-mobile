import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:scannerv3/fragments/about_fragment.dart';
import 'package:scannerv3/fragments/classes_fragment.dart';
import 'package:scannerv3/fragments/exams_fragment.dart';
import 'package:scannerv3/fragments/grade_fragment.dart';
import 'package:scannerv3/screens/welcome_screen.dart';
import 'package:scannerv3/utils/token_manager.dart';

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
    const AboutFragment()
  ];
  late StreamSubscription<List<ConnectivityResult>> subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      // Received changes in available connectivity types!
      if (result.contains(ConnectivityResult.none)) {
        _showOfflineDialog();
      }

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    subscription.cancel();
    super.dispose();

  }

  void _showOfflineDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Internet Connection'),
          content: Text('You are currently offline. Only local changes can be seen.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(41, 46, 50, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(101, 188, 80, 1),
        leading: Padding(
            padding: const EdgeInsets.only(left: 12),
            child:
                Image.asset('assets/images/logo.png', width: 32, height: 32)),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ElevatedButton(
                  onPressed: () async {
                    if (await TokenManager().removeAuthToken()) {
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WelcomeScreen()),
                            (route) => false);
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "Cannot sign out.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  child: const Icon(Iconsax.logout,
                      color: Color.fromRGBO(101, 188, 80, 1))))
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromRGBO(101, 188, 80, 1),
        fixedColor: Colors.white,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        onTap: onTappedBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.document), label: "Exams"),
          BottomNavigationBarItem(icon: Icon(Iconsax.people), label: "Classes"),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.profile_circle), label: "About"),
        ],
      ),
    );
  }
}
