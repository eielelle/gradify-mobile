class ResponseOffline {
  final int? id;
  final int examId;
  final String studentNumber;
  final String imagePath;
  final int detected;
  final int score;
  final String answer;
  final DateTime createdAt;

  final String name;
  final String email;

  ResponseOffline({this.id, required this.examId, required this.studentNumber, required this.imagePath, required this.detected, required this.score, required this.answer, required this.createdAt, this.name = "", this.email = ""});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'examId': examId,
      'studentNumber': studentNumber,
      'imagePath': imagePath,
      'detected': detected,
      'score': score,
      'answer': answer,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static ResponseOffline fromMap(Map<String, dynamic> map) {
    return ResponseOffline(
      id: map['id'],
      examId: map['examId'],
      studentNumber: map['studentNumber'],
      imagePath: map['imagePath'],
      detected: map['detected'],
      score: map['score'],
      answer: map['answer'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

}