import 'package:scannerv3/models/quarter.dart';
import 'package:scannerv3/models/subject.dart';

class Exam {
  final int id;
  final String name;
  final String answerKey;
  final DateTime createdAt;
  final String quarterName;
  final String subjectName;
  final int responses;

  Exam({required this.id, required this.name, required this.answerKey, required this.createdAt, required this.quarterName, required this.subjectName, required this.responses});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'answerKey': answerKey,
      'createdAt': createdAt.toIso8601String(),
      'quarterName': quarterName,
      'subjectName': subjectName,
      'responses': responses
    };
  }

  static Exam fromMap(Map<String, dynamic> map) {
    return Exam(
      id: map['id'],
      name: map['name'],
      answerKey: map['answerKey'],
      createdAt: DateTime.parse(map['createdAt']),
      quarterName: map['quarterName'],
      subjectName: map['subjectName'],
      responses: map['responses']
    );
  }
}