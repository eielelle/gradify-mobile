import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;
import 'package:scannerv3/models/exam.dart';
import 'package:scannerv3/scanner.dart';
import 'package:scannerv3/screens/results_screen.dart';

class ImagePreviewScreen extends StatefulWidget {
  final String imagePath;
  final Exam exam;

  const ImagePreviewScreen(
      {super.key, required this.imagePath, required this.exam});

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  Future<Widget> processImage(String imagePath) async {
    cv.Mat img = cv.imread(imagePath);

    var threshImg = await Scanner().getThreshGauss(img);
    // var b = await Scanner().findBubbles(img, a); // draw a contour :reminder
    // var warped = await Scanner().processImg(img);
    var squares = await Scanner().findSquares(threshImg);
    var warped = await Scanner().processImg(img, squares);

    // second
    var threshWarped = await Scanner().getThreshMean(warped);
    var bubbles = await Scanner().findBubbles(warped, threshWarped);

    (bool, Uint8List) encodedImg = cv.imencode(".png", bubbles.img);

    return Column(
      children: [
        Image.memory(encodedImg.$2),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(101, 188, 80, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Set border radius
              ),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResultsScreen(
                          exam: widget.exam,
                          answer: bubbles.result.split(''),
                          studentId: bubbles.studentId,
                          answerKey: widget.exam.answerKey.split(''))));
            },
            child:
                const Text("See Result", style: TextStyle(color: Colors.white)))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(41, 46, 50, 1),
      appBar: AppBar(
          title: Text("Result"),
          backgroundColor: const Color.fromRGBO(101, 188, 80, 1)),
      body: Center(
        child: FutureBuilder(
            future: processImage(widget.imagePath),
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading spinner while waiting for the image
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Show an error message if something went wrong
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                // When the image data is available, show the image
                return snapshot.data!;
              } else {
                // If no data, show a fallback widget (optional)
                return Text('No image available');
              }
            }),
      ),
    );
  }
}
