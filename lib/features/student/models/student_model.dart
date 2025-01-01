import '../../auth/models/user_model.dart';

class StudentModel {
  final String name;
  final String gender;
  final DateTime birthDate;
  final String? avatar;
  final UserModel? parent;

//<editor-fold desc="Data Methods">

  StudentModel({
    required this.name,
    required this.gender,
    required this.birthDate,
    this.avatar,
    this.parent,
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
          parent == other.parent);

  @override
  int get hashCode =>
      name.hashCode ^
      gender.hashCode ^
      birthDate.hashCode ^
      avatar.hashCode ^
      parent.hashCode;

  @override
  String toString() {
    return 'StudentModel{' +
        ' name: $name,' +
        ' gender: $gender,' +
        ' birthDate: $birthDate,' +
        ' avatar: $avatar,' +
        ' parent: $parent,' +
        '}';
  }

  StudentModel copyWith({
    String? name,
    String? gender,
    DateTime? birthDate,
    String? avatar,
    UserModel? parent,
  }) {
    return StudentModel(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      avatar: avatar ?? this.avatar,
      parent: parent ?? this.parent,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'gender': this.gender,
      'birthDate': this.birthDate,
      'avatar': this.avatar,
      'parent': this.parent,
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      name: map['name'] as String,
      gender: map['gender'] as String,
      birthDate: map['birthDate'] as DateTime,
      avatar: map['avatar'] as String,
      parent: map['parent'] as UserModel,
    );
  }

//</editor-fold>
}
