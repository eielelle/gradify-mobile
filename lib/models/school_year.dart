class SchoolYear {
  final int id;
  final String name;
  final String startDate;
  final String endDate;

  SchoolYear({required this.id, required this.name, required this.startDate, required this.endDate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  static SchoolYear fromMap(Map<String, dynamic> map) {
    return SchoolYear(
      id: map['id'],
      name: map['name'],
      startDate: map['startDate'],
      endDate: map['endDate']
    );
  }
}