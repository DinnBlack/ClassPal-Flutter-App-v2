enum Role { Principal, VicePrincipal, Teacher, AssistantTeacher }

class TeacherModel {
  String userId;
  String name;
  Role? role;

//<editor-fold desc="Data Methods">
  TeacherModel({
    required this.userId,
    required this.name,
    this.role,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TeacherModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          name == other.name &&
          role == other.role);

  @override
  int get hashCode => userId.hashCode ^ name.hashCode ^ role.hashCode;

  @override
  String toString() {
    return 'TeacherModel{' +
        ' userId: $userId,' +
        ' name: $name,' +
        ' role: $role,' +
        '}';
  }

  TeacherModel copyWith({
    String? userId,
    String? name,
    Role? role,
  }) {
    return TeacherModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'name': this.name,
      'role': this.role,
    };
  }

  factory TeacherModel.fromMap(Map<String, dynamic> map) {
    return TeacherModel(
      userId: map['userId'] as String,
      name: map['name'] as String,
      role: map['role'] as Role,
    );
  }

//</editor-fold>
}