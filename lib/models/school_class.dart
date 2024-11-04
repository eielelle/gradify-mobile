class SchoolClass {
  final int id;
  final String name;
  final String description;

  SchoolClass({required this.id, required this.name, required this.description});

 Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description
    };
  }

  static SchoolClass fromMap(Map<String, dynamic> map) {
    return SchoolClass(
      id: map['id'],
      name: map['name'],
      description: map['description']
    );
  }
}