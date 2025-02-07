class RoleModel {
  final String id;
  final String name;
  final bool isLocked;

//<editor-fold desc="Data Methods">
  const RoleModel({
    required this.id,
    required this.name,
    required this.isLocked,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoleModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          isLocked == other.isLocked);

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ isLocked.hashCode;

  @override
  String toString() {
    return 'RoleModel{' +
        ' id: $id,' +
        ' name: $name,' +
        ' isLocked: $isLocked,' +
        '}';
  }

  RoleModel copyWith({
    String? id,
    String? name,
    bool? isLocked,
  }) {
    return RoleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'isLocked': this.isLocked,
    };
  }

  factory RoleModel.fromMap(Map<String, dynamic> map) {
    return RoleModel(
      id: map['id'] ?? map['_id'] as String,
      name: map['name'] as String,
      isLocked: map['isLocked'] as bool,
    );
  }

//</editor-fold>
}