class Section {
  final int id;
  final String name;

  Section({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  static Section fromMap(Map<String, dynamic> map) {
    return Section(
      id: map['id'],
      name: map['name'],
    );
  }
}