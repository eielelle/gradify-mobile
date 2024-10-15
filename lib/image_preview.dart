import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;
import 'package:scannerv3/scanner.dart';

class ImagePreviewScreen extends StatefulWidget {
  final String imagePath;

  const ImagePreviewScreen({super.key, required this.imagePath});

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  Future<Image> processImage(String imagePath) async {
    cv.Mat img = cv.imread(imagePath);

    var threshImg = await Scanner().getThreshGauss(img);
    // var b = await Scanner().findBubbles(img, a); // draw a contour :reminder
    // var warped = await Scanner().processImg(img);
    var squares = await Scanner().findSquares(threshImg);
    var warped = await Scanner().processImg(img, squares);

    // second
    var threshWarped = await Scanner().getThreshMean(warped);
    var bubbles = await Scanner().findBubbles(warped, threshWarped);

    (bool, Uint8List) encodedImg = cv.imencode(".png", bubbles);

    return Image.memory(encodedImg.$2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
      ),
      body: Center(
        child: FutureBuilder(
            future: processImage(widget.imagePath),
            builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
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
