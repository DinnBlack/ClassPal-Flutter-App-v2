import '../../auth/models/user_model.dart';

class StudentModel {
  final String name;
  final String gender;
  final DateTime birthDate;
  final String? avatar;
  final String? parentId;
  final String? userId;

//<editor-fold desc="Data Methods">

  const StudentModel({
    required this.name,
    required this.gender,
    required this.birthDate,
    this.avatar,
    this.parentId,
    this.userId,
  });

// Re@override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudentModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          gender == other.gender &&
          birthDate == other.birthDate &&
          avatar == other.avatar &&
          parentId == other.parentId &&
          userId == other.userId);

  @override
  int get hashCode =>
      name.hashCode ^
      gender.hashCode ^
      birthDate.hashCode ^
      avatar.hashCode ^
      parentId.hashCode ^
      userId.hashCode;

  @override
  String toString() {
    return 'StudentModel{' +
        ' name: $name,' +
        ' gender: $gender,' +
        ' birthDate: $birthDate,' +
        ' avatar: $avatar,' +
        ' parentId: $parentId,' +
        ' userId: $userId,' +
        '}';
  }

  StudentModel copyWith({
    String? name,
    String? gender,
    DateTime? birthDate,
    String? avatar,
    String? parentId,
    String? userId,
  }) {
    return StudentModel(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      avatar: avatar ?? this.avatar,
      parentId: parentId ?? this.parentId,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'gender': this.gender,
      'birthDate': this.birthDate,
      'avatar': this.avatar,
      'parentId': this.parentId,
      'userId': this.userId,
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      name: map['name'] as String,
      gender: map['gender'] as String,
      birthDate: map['birthDate'] as DateTime,
      avatar: map['avatar'] as String,
      parentId: map['parentId'] as String,
      userId: map['userId'] as String,
    );
  }

//</editor-fold>
}
