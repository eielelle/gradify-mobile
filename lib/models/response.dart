class Response {
  final int id;
  final int examId;
  final int userId;
  final String studentNumber;
  final String imagePath;
  final int detected;
  final int score;
  final String answer;
  final DateTime createdAt;

  Response(this.id, this.examId, this.userId, this.studentNumber, this.imagePath, this.detected, this.score, this.answer, this.createdAt);
}