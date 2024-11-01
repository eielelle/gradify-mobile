class ExamOffline {
  final int id;
  final String name;
  final String answerKey;
  final DateTime createdAt;
  
  final int quarterId;
  final int subjectId;

  ExamOffline(this.id, this.name, this.answerKey, this.createdAt, this.quarterId, this.subjectId);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'answerKey': answerKey,
      'createdAt': createdAt.toIso8601String(),
      'quarterId': quarterId,
      'subjectId': subjectId,
    };
  }

  static ExamOffline fromMap(Map<String, dynamic> map) {
    return ExamOffline(
      map['id'],
      map['name'],
      map['answerKey'],
      DateTime.parse(map['createdAt']),
      map['quarterId'],
      map['subjectId'],
    );
  }
}