class GradeTypeModel {
  final String id;
  final String name;

//<editor-fold desc="Data Methods">
  const GradeTypeModel({
    required this.id,
    required this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GradeTypeModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name);

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() {
    return 'GradeTypeModel{' + ' id: $id,' + ' name: $name,' + '}';
  }

  GradeTypeModel copyWith({
    String? id,
    String? name,
  }) {
    return GradeTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
    };
  }

  factory GradeTypeModel.fromMap(Map<String, dynamic> map) {
    return GradeTypeModel(
      id: map['_id'] as String,
      name: map['name'] as String,
    );
  }

//</editor-fold>
}