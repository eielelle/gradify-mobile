class ResponseOffline {
  final int id;
  final int examId;
  final int userId;
  final String studentNumber;
  final String imagePath;
  final int detected;
  final int score;
  final String answer;
  final DateTime createdAt;

  ResponseOffline(this.id, this.examId, this.userId, this.studentNumber, this.imagePath, this.detected, this.score, this.answer, this.createdAt);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'examId': examId,
      'userId': userId,
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
      map['id'],
      map['examId'],
      map['userId'],
      map['studentNumber'],
      map['imagePath'],
      map['detected'],
      map['score'],
      map['answer'],
      DateTime.parse(map['createdAt']),
    );
  }

}