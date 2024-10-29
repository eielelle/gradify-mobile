import 'package:opencv_dart/opencv_dart.dart' as cv;

class Scan {
  final String studentId;
  final String first;
  final String second;
  final cv.Mat img;
  final String result;

  Scan(this.studentId, this.first, this.second, this.img, this.result);
}