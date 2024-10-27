import 'package:scannerv3/models/quarter.dart';
import 'package:scannerv3/models/subject.dart';

class Exam {
  final int id;
  final String name;
  final String answerKey;
  final DateTime createdAt;
  final Quarter quarter;
  final Subject subject;

  Exam(this.quarter, this.subject, {required this.id, required this.name, required this.answerKey, required this.createdAt});
}