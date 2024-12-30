class StudentModel {
  final String name;
  final String gender;
  final DateTime birthDate;
  final String? avatar;

//<editor-fold desc="Data Methods">
  const StudentModel({
    required this.name,
    required this.gender,
    required this.birthDate,
    this.avatar,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudentModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          gender == other.gender &&
          birthDate == other.birthDate &&
          avatar == other.avatar);

  @override
  int get hashCode =>
      name.hashCode ^ gender.hashCode ^ birthDate.hashCode ^ avatar.hashCode;

  @override
  String toString() {
    return 'StudentModel{' +
        ' name: $name,' +
        ' gender: $gender,' +
        ' birthDate: $birthDate,' +
        ' avatar: $avatar,' +
        '}';
  }

  StudentModel copyWith({
    String? name,
    String? gender,
    DateTime? birthDate,
    String? avatar,
  }) {
    return StudentModel(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'gender': this.gender,
      'birthDate': this.birthDate,
      'avatar': this.avatar,
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      name: map['name'] as String,
      gender: map['gender'] as String,
      birthDate: map['birthDate'] as DateTime,
      avatar: map['avatar'] as String,
    );
  }

//</editor-fold>
}