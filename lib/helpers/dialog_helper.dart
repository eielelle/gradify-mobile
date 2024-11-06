import 'package:flutter/material.dart';

class DialogHelper {
  static void showCustomDialog(
      {required String title,
      required String subtitle,
      required BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(subtitle),
          actions: [
            Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(101, 188, 80, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Set border radius
                    ),
                  ),
                  child:
                      const Text('OK', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                )),
          ],
        );
      },
    );
  }
}
