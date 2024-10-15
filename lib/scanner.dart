import 'package:opencv_dart/core.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;
import 'package:scannerv3/scanner_utils.dart';

class Scanner {
  // this method find the 4 corner squares
  Future<List<List<Point>>> findSquares(cv.Mat thresh) async {
    (VecVecPoint, cv.Mat) cnts =
        cv.findContours(thresh, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE);
    List<List<Point>> squares = [];

    for (VecPoint c in cnts.$1) {
      Rect rect = await cv.boundingRectAsync(c);
      double ar = rect.width / rect.height;

      if (rect.width >= 20 && rect.height >= 20 && ar >= 0.9 && ar <= 1.1) {
        squares.add(c.toList());
      }
    }

    return squares;
  }

  // process the image into a warped format
  Future<cv.Mat> processImg(cv.Mat img, List<List<Point>> points) async {
    // Get original image dimensions
    int width = img.cols;
    int height = img.rows;

    // Define source points (these can be adjusted based on your needs)
    List<Point> srcPoints = [];

    // assign points
    for (List<Point> point in points) {
      var x = cv.boundingRect(VecPoint.fromList(point));
      int centerX = x.x + (x.width ~/ 2);
      int centerY = x.y + (x.height ~/ 2);

      srcPoints.add(Point(centerX, centerY));
    }

    srcPoints = ScannerUtils().sortPointsClockwise(srcPoints);

    // Define destination points (also corners of the whole image)
    List<Point> dstPoints = [
      Point(0, 0), // Top-left corner
      Point(width, 0), // Top-right corner
      Point(width, height), // Bottom-right corner
      Point(0, height) // Bottom-left corner
    ];

    // Create the perspective transformation matrix
    Mat transformMatrix = cv.getPerspectiveTransform(
        VecPoint.fromList(srcPoints), VecPoint.fromList(dstPoints));

    // Apply the perspective transformation
    Mat warpedImage = cv.warpPerspective(img, transformMatrix, (width, height));

    return warpedImage;
  }

  Future<cv.Mat> getThreshMean(cv.Mat img) async {
    cv.Mat gray = await cv.cvtColorAsync(img, cv.COLOR_BGR2GRAY);
    cv.Mat blur = await cv.gaussianBlurAsync(gray, (1, 1), 0);
    var a = cv.adaptiveThreshold(
        blur, 255, cv.ADAPTIVE_THRESH_MEAN_C, cv.THRESH_BINARY_INV, 11, 11);

    return a;
  }

  Future<cv.Mat> getThreshGauss(cv.Mat img) async {
    cv.Mat gray = await cv.cvtColorAsync(img, cv.COLOR_BGR2GRAY);
    cv.Mat blur = await cv.gaussianBlurAsync(gray, (1, 1), 0);
    var a = cv.adaptiveThreshold(
        blur, 255, cv.ADAPTIVE_THRESH_GAUSSIAN_C, cv.THRESH_BINARY_INV, 11, 11);

    return a;
  }

  Future<cv.Mat> getOtsu(cv.Mat img) async {
    cv.Mat gray = await cv.cvtColorAsync(img, cv.COLOR_BGR2GRAY);
    cv.Mat blur = await cv.gaussianBlurAsync(gray, (1, 1), 0);
    // var a = cv.adaptiveThreshold(
    //     blur, 255, cv.ADAPTIVE_THRESH_GAUSSIAN_C, cv.THRESH_BINARY_INV, 11, 11);
    var b = cv.threshold(blur, 0, 255, cv.THRESH_BINARY_INV | cv.THRESH_OTSU);

    return b.$2;
  }

  // find the bubbles and sort them
  Future<Mat> findBubbles(cv.Mat orig, cv.Mat thresh) async {
    (VecVecPoint, cv.Mat) cnts =
        cv.findContours(thresh, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE);
    List<List<Point>> bubbles = [];

    for (VecPoint c in cnts.$1) {
      Rect rect = await cv.boundingRectAsync(c);
      double ar = rect.width / rect.height;

      if (rect.width >= 13 && rect.height >= 13 && ar >= 0.8 && ar <= 1.2) {
        if (rect.x == 0 || rect.x >= orig.width - 20) {
          continue;
        }

        bubbles.add(c.toList());
      }
    }

    // sort contours from top to bottom
    var sorted = ScannerUtils().sortContours(bubbles, 'top-to-bottom');
    var studSection = ScannerUtils().getStudentIdSection(sorted);
    var firstPart =
        ScannerUtils().getFirstSection(sorted, studSection.lastYPos);
    var studentid = "";

    // determine the student id
    for (var studRow in studSection.rows) {
      var sortedRow = ScannerUtils().sortContours(studRow, "left-to-right");

      var num = applyMask(sortedRow, thresh);
      studentid += num.toString();
      print("FILLED BUBBLES");
      print(num);
    }

    print("SEE");
    print(sorted.length);
    print("YOUR STUDENT ID IS: $studentid");

    Scalar color = Scalar(0, 255, 0);
    // return cv.drawContoursAsync(orig, VecVecPoint.fromList(stud[0]), -1, color,
    //     thickness: 2);
    return cv.drawContoursAsync(orig, VecVecPoint.fromList(bubbles), -1, color,
        thickness: 2);
  }

  // returns index of filled bubble
  int? applyMask(List<List<cv.Point>> contours, cv.Mat thresh) {
    int? bubbledCount;
    int? bubbledIndex;

    for (int j = 0; j < contours.length; j++) {
      var contour = contours[j];

      // Construct a mask that reveals only the current "bubble" for the question
      var mask = cv.Mat.zeros(thresh.rows, thresh.cols, MatType.CV_8UC1);
      cv.drawContours(
          mask, VecVecPoint.fromList([contour]), -1, cv.Scalar.all(255),
          thickness: cv.FILLED);

      // Apply the mask to the thresholded image
      var masked = cv.bitwiseAND(thresh, thresh, mask: mask);

      // Count the number of non-zero pixels in the bubble area
      int total = cv.countNonZero(masked);

      // print("NONZERO: $total");

      // Check if the current total has a larger number of non-zero pixels
      if (bubbledCount == null || total > bubbledCount) {
        bubbledCount = total;
        bubbledIndex = j;
      }
    }

    // At this point, bubbledCount contains the max non-zero count,
    // and bubbledIndex contains the index of the bubbled contour
    print("Bubbled Index: $bubbledIndex, Count: $bubbledCount");
    return bubbledIndex;
  }
}
