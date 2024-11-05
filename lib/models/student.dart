class Student {
  final String name;
  final String student_number;

  Student({required this.name, required this.student_number});

    Map<String, dynamic> toMap() {
    return {
      'student_number': student_number,
      'name': name,
    };
  }

  static Student fromMap(Map<String, dynamic> map) {
    return Student(
      student_number: map['student_number'],
      name: map['name'],
    );
  }
}