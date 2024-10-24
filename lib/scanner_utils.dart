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

  // first section part
  Future<List<List<List<cv.Point>>>> getFirstSection(
      List<List<cv.Point>> contours) async {
    List<List<List<cv.Point>>> finalRows = [];
    List<List<List<cv.Point>>> sortedRows = [];
    List<List<List<cv.Point>>> unsortedRows = [];
    List<List<cv.Point>> tempList = [];
    var startingYPos = 220;
    var bubbleHeight = 20;
    var gap = 60;

    for (int i = 0; i < contours.length; i++) {
      var bound = await cv.boundingRectAsync(VecPoint.fromList(contours[i]));

      if (unsortedRows.length == 10) {
        break;
      }

      if (bound.y >= startingYPos && bound.y < (startingYPos + bubbleHeight)) {
        tempList.add(contours[i]);
        continue;
      }

      if (bound.y > (startingYPos + bubbleHeight)) {
        unsortedRows.add(tempList);
        tempList = [];
        startingYPos += 20;

        // check if within boundaries
        if (bound.y >= startingYPos &&
            bound.y < (startingYPos + bubbleHeight)) {
          tempList.add(contours[i]);
          continue;
        }
      }
    }

    // sorting rows
    for (var row in unsortedRows) {
      var sorted = ScannerUtils().sortContours(row, "left-to-right");

      sortedRows.add(sorted);
    }

    // split
    for (var row in sortedRows) {
      List<List<cv.Point>> tempList = [];

      for (int i = 0; i < row.length; i++) {
        var bound = await cv.boundingRectAsync(VecPoint.fromList(row[i]));
        var nextIdx = i + 1;

        if (nextIdx != row.length) {
          var nextBnd =
              await cv.boundingRectAsync(VecPoint.fromList(row[nextIdx]));

          if ((nextBnd.x - bound.x) > gap) {
            tempList.add(row[i]);
            finalRows.add(tempList);
            tempList = [];
          } else {
            tempList.add(row[i]);
          }
        } else {
          tempList.add(row[i]);
          finalRows.add(tempList);
          tempList = [];
        }
      }
    }

    // print("UNSORTED RIWS 1");
    // print(finalRows[23].length);
    return finalRows;
  }

  Future<List<List<List<cv.Point>>>> getSecondSection(
      List<List<cv.Point>> contours) async {
    List<List<List<cv.Point>>> finalRows = [];
    List<List<List<cv.Point>>> sortedRows = [];
    List<List<List<cv.Point>>> unsortedRows = [];
    List<List<cv.Point>> tempList = [];
    var startingYPos = 480;
    var bubbleHeight = 20;
    var gap = 90;

    for (int i = 0; i < contours.length; i++) {
      var bound = await cv.boundingRectAsync(VecPoint.fromList(contours[i]));

      if (unsortedRows.length == 9 && tempList.isNotEmpty) {
        unsortedRows.add(tempList);
      }

      if (bound.y >= startingYPos && bound.y < (startingYPos + bubbleHeight)) {
        tempList.add(contours[i]);
        continue;
      }

      if (bound.y > (startingYPos + bubbleHeight)) {
        unsortedRows.add(tempList);
        tempList = [];
        startingYPos += 20;

        // check if within boundaries
        if (bound.y >= startingYPos &&
            bound.y < (startingYPos + bubbleHeight)) {
          tempList.add(contours[i]);
          continue;
        }
      }
    }

    print("UNSORTED");
    print(unsortedRows.length);
    // sorting rows
    for (var row in unsortedRows) {
      var sorted = ScannerUtils().sortContours(row, "left-to-right");

      sortedRows.add(sorted);
    }

    // split
    for (var row in sortedRows) {
      List<List<cv.Point>> tempList = [];

      for (int i = 0; i < row.length; i++) {
        var bound = await cv.boundingRectAsync(VecPoint.fromList(row[i]));
        var nextIdx = i + 1;

        if (nextIdx != row.length) {
          var nextBnd =
              await cv.boundingRectAsync(VecPoint.fromList(row[nextIdx]));

          if ((nextBnd.x - bound.x) > gap) {
            tempList.add(row[i]);
            finalRows.add(tempList);
            tempList = [];
          } else {
            tempList.add(row[i]);
          }
        } else {
          tempList.add(row[i]);
          finalRows.add(tempList);
          tempList = [];
        }
      }
    }

    print("FINAL");
    print(sortedRows.length);
    print(finalRows.length);
    return finalRows;
  }

  // pass sorted y
  Future<SectionField> getStudentIdSection(
      List<List<cv.Point>> contours) async {
    List<List<List<cv.Point>>> studentsRows = [];
    List<List<cv.Point>> tempList = [];
    var bubbleHeight = 20;
    var startingYPos = 40;

    for (int i = 0; i < contours.length; i++) {
      var bound = await cv.boundingRectAsync(VecPoint.fromList(contours[i]));

      if (studentsRows.length == 5) {
        break;
      }

      // check if within boundaries
      if (bound.y >= startingYPos && bound.y < (startingYPos + bubbleHeight)) {
        // print("ADDED");
        // print(bound.y);
        tempList.add(contours[i]);
        continue;
      }

      if (bound.y > (startingYPos + bubbleHeight)) {
        studentsRows.add(tempList);
        tempList = [];
        startingYPos += 20;

        // check if within boundaries
        if (bound.y >= startingYPos &&
            bound.y < (startingYPos + bubbleHeight)) {
          tempList.add(contours[i]);
          continue;
        }
      }
    }

    // sort all rows
    return SectionField(studentsRows, startingYPos + bubbleHeight);
  }
}
