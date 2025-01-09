class TeacherModel {
  final String userId;
  final String name;
  final bool isAccepted;
  final String avatar;
  final String email;
  final String phoneNumber;

  //<editor-fold desc="Data Methods">
  const TeacherModel({
    required this.userId,
    required this.name,
    required this.isAccepted,
    required this.avatar,
    required this.email,
    required this.phoneNumber,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is TeacherModel &&
              runtimeType == other.runtimeType &&
              userId == other.userId &&
              name == other.name &&
              isAccepted == other.isAccepted &&
              avatar == other.avatar &&
              email == other.email &&
              phoneNumber == other.phoneNumber);

  @override
  int get hashCode =>
      userId.hashCode ^
      name.hashCode ^
      isAccepted.hashCode ^
      avatar.hashCode ^
      email.hashCode ^
      phoneNumber.hashCode;

  @override
  String toString() {
    return 'TeacherModel{' +
        ' userId: $userId,' +
        ' name: $name,' +
        ' isAccepted: $isAccepted,' +
        ' avatar: $avatar,' +
        ' email: $email,' +
        ' phoneNumber: $phoneNumber,' +
        '}';
  }

  TeacherModel copyWith({
    String? userId,
    String? name,
    bool? isAccepted,
    String? avatar,
    String? email,
    String? phoneNumber,
  }) {
    return TeacherModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      isAccepted: isAccepted ?? this.isAccepted,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'name': this.name,
      'isAccepted': this.isAccepted,
      'avatar': this.avatar,
      'email': this.email,
      'phoneNumber': this.phoneNumber,
    };
  }

  factory TeacherModel.fromMap(Map<String, dynamic> map) {
    return TeacherModel(
      userId: map['userId'] as String,
      name: map['name'] as String,
      isAccepted: map['isAccepted'] as bool,
      avatar: map['avatar'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
    );
  }
//</editor-fold>
}
