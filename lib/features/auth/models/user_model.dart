class UserModel {
  final String userId;
  final String name;
  final String emailOrPhoneNumber;
  final String password;
  final String? avatar;
  final List<String> schoolIds;
  final List<String> classIds;

//<editor-fold desc="Data Methods">
  const UserModel({
    required this.userId,
    required this.name,
    required this.emailOrPhoneNumber,
    required this.password,
    this.avatar,
    required this.schoolIds,
    required this.classIds,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          name == other.name &&
          emailOrPhoneNumber == other.emailOrPhoneNumber &&
          password == other.password &&
          avatar == other.avatar &&
          schoolIds == other.schoolIds &&
          classIds == other.classIds);

  @override
  int get hashCode =>
      userId.hashCode ^
      name.hashCode ^
      emailOrPhoneNumber.hashCode ^
      password.hashCode ^
      avatar.hashCode ^
      schoolIds.hashCode ^
      classIds.hashCode;

  @override
  String toString() {
    return 'UserModel{' +
        ' userId: $userId,' +
        ' name: $name,' +
        ' emailOrPhoneNumber: $emailOrPhoneNumber,' +
        ' password: $password,' +
        ' avatar: $avatar,' +
        ' schoolIds: $schoolIds,' +
        ' classIds: $classIds,' +
        '}';
  }

  UserModel copyWith({
    String? userId,
    String? name,
    String? emailOrPhoneNumber,
    String? password,
    String? avatar,
    List<String>? schoolIds,
    List<String>? classIds,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      emailOrPhoneNumber: emailOrPhoneNumber ?? this.emailOrPhoneNumber,
      password: password ?? this.password,
      avatar: avatar ?? this.avatar,
      schoolIds: schoolIds ?? this.schoolIds,
      classIds: classIds ?? this.classIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'name': this.name,
      'emailOrPhoneNumber': this.emailOrPhoneNumber,
      'password': this.password,
      'avatar': this.avatar,
      'schoolIds': this.schoolIds,
      'classIds': this.classIds,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] as String,
      name: map['name'] as String,
      emailOrPhoneNumber: map['emailOrPhoneNumber'] as String,
      password: map['password'] as String,
      avatar: map['avatar'] as String,
      schoolIds: map['schoolIds'] as List<String>,
      classIds: map['classIds'] as List<String>,
    );
  }

//</editor-fold>
}
