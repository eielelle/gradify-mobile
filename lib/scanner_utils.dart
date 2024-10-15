import 'dart:math';

import 'package:opencv_dart/core.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;
import 'package:scannerv3/section_field.dart';

class ScannerUtils {
  void removeShadow(cv.Mat img) {}

  // this gets the for square points and sort them clockwise
  List<Point> sortPointsClockwise(List<Point> points) {
    // Calculate the centroid
    double centroidX =
        points.map((p) => p.x).reduce((a, b) => a + b) / points.length;
    double centroidY =
        points.map((p) => p.y).reduce((a, b) => a + b) / points.length;

    // Sort points based on their angles
    points.sort((a, b) => atan2(a.y - centroidY, a.x - centroidX)
        .compareTo(atan2(b.y - centroidY, b.x - centroidX)));

    return points;
  }

  // Function to sort contours by their bounding box (top-to-bottom or left-to-right)
  List<List<cv.Point>> sortContours(
      List<List<cv.Point>> contours, String method) {
    // Sort contours based on the x or y coordinate of the bounding box
    contours.sort((cntA, cntB) {
      cv.Rect boxA = cv.boundingRect(VecPoint.fromList(cntA));
      cv.Rect boxB = cv.boundingRect(VecPoint.fromList(cntB));

      if (method == "top-to-bottom") {
        return boxA.y.compareTo(boxB.y);
      } else if (method == "left-to-right") {
        return boxA.x.compareTo(boxB.x);
      }

      return 0;
    });

    return contours;
  }

  List<List<cv.Point>> getFirstSection(
      List<List<cv.Point>> contours, int lastPosY) {
    List<List<List<cv.Point>>> studentsRows = [];
    var y = lastPosY;
    var x = 0;
    var bubbleHeight = 20;
    List<List<cv.Point>> tempList = [];

    print("LAST POS IS $y");

    var count = 0;

    for (var contour in contours) {
      var bound = cv.boundingRect(VecPoint.fromList(contour));

      // skips 50
      if (bound.y < lastPosY - 50) {
        y = bound.y ~/ 10 * 10 + 20;
        continue;
      }

      if (studentsRows.length == 10) {
        // return SectionField(studentsRows, y);
        break;
      }

      // Check if we have reached a new row
      if (bound.y >= y) {
        // Only add the row if it contains contours
        if (tempList.isNotEmpty) {
          // split rows
          

          studentsRows.add(tempList);
          tempList = [];
        }

        // Update the new y boundary
        x = 0;
        y = bound.y ~/ 10 * 10 + 20;
      }

      if (tempList.length < 15) {
        tempList.add(contour);
      }
    }

    // sort each row and split them

    print("TOTAL ELEMENTS AaFTER: $count");
    return studentsRows[0];
  }

  // pass sorted y
  SectionField getStudentIdSection(List<List<cv.Point>> contours) {
    List<List<List<cv.Point>>> studentsRows = [];
    var y = 0;
    var bubbleHeight = 20;
    List<List<cv.Point>> tempList = [];

    for (var contour in contours) {
      var bound = cv.boundingRect(VecPoint.fromList(contour));

      if (studentsRows.length == 5) {
        return SectionField(studentsRows, y);
      }

      // Initialize the first row
      if (y == 0) {
        y = bound.y ~/ 10 * 10 + 20;
        tempList.add(contour);
        continue;
      }

      // Check if we have reached a new row
      if (bound.y >= y) {
        // Only add the row if it contains contours
        if (tempList.isNotEmpty) {
          studentsRows.add(tempList);
          tempList = [];
        }

        // Update the new y boundary
        y = bound.y ~/ 10 * 10 + 20;
      }

      // Add contour to the current row if we have not exceeded the limit
      if (tempList.length < 10) {
        tempList.add(contour);
      }
    }

    // Add the last row if it contains contours
    if (tempList.isNotEmpty) {
      studentsRows.add(tempList);
    }

    return SectionField(studentsRows, y);
  }
}
