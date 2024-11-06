import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

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
                title: const Text(
                  "My Account",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Color.fromRGBO(101, 188, 80, 1)),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Row(children: [
                      const Text("Name: ",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      Text(
                        name,
                        style: const TextStyle(color: Colors.white),
                      )
                    ]),
                    Row(children: [
                      const Text("Email: ",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      Text(
                        email,
                        style: const TextStyle(color: Colors.white),
                      )
                    ]),
                    SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              try {
                                // Load the PDF file from assets as bytes
                                final ByteData data = await rootBundle.load(
                                    'assets/files/gradify-exam-paper.pdf');
                                final buffer = data.buffer.asUint8List();

                                // Get the temporary directory to save the file
                                final directory = await getTemporaryDirectory();
                                final filePath =
                                    '${directory.path}/gradify-exam-paper.pdf';
                                final file = File(filePath);

                                // Write the PDF bytes to the file
                                await file.writeAsBytes(buffer);

                                // Share the PDF file
                                await Share.shareXFiles(
                                  [XFile(filePath)],
                                );
                              } catch (error) {
                                Fluttertoast.showToast(
                                    msg: "Cannot print at the moment",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Set border radius
                              ),
                            ),
                            child: const Text(
                              "Print Exam Paper",
                              style: TextStyle(
                                  color: Color.fromRGBO(101, 188, 80, 1)),
                            ))),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              SystemNavigator.pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(101, 188, 80, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Set border radius
                              ),
                            ),
                            child: const Text(
                              "Exit",
                              style: TextStyle(color: Colors.white),
                            ))),
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Version 1.0",
                              style: TextStyle(color: Colors.white))
                        ])
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
