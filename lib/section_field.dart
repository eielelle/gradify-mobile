import 'package:opencv_dart/opencv_dart.dart' as cv;

class SectionField {
  final List<List<List<cv.Point>>> rows;
  final int lastYPos;

  SectionField(this.rows, this.lastYPos);
}