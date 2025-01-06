class UserModel {
  final String userId;
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final List<String> schoolIds;
  final List<String> classIds;

//<editor-fold desc="Data Methods">
  const UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.password,
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
          email == other.email &&
          phoneNumber == other.phoneNumber &&
          password == other.password &&
          schoolIds == other.schoolIds &&
          classIds == other.classIds);

  @override
  int get hashCode =>
      userId.hashCode ^
      name.hashCode ^
      email.hashCode ^
      phoneNumber.hashCode ^
      password.hashCode ^
      schoolIds.hashCode ^
      classIds.hashCode;

  @override
  String toString() {
    return 'UserModel{' +
        ' userId: $userId,' +
        ' name: $name,' +
        ' email: $email,' +
        ' phoneNumber: $phoneNumber,' +
        ' password: $password,' +
        ' schoolIds: $schoolIds,' +
        ' classIds: $classIds,' +
        '}';
  }

  UserModel copyWith({
    String? userId,
    String? name,
    String? email,
    String? phoneNumber,
    String? password,
    List<String>? schoolIds,
    List<String>? classIds,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      schoolIds: schoolIds ?? this.schoolIds,
      classIds: classIds ?? this.classIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'name': this.name,
      'email': this.email,
      'phoneNumber': this.phoneNumber,
      'password': this.password,
      'schoolIds': this.schoolIds,
      'classIds': this.classIds,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      password: map['password'] as String,
      schoolIds: map['schoolIds'] as List<String>,
      classIds: map['classIds'] as List<String>,
    );
  }

//</editor-fold>
}
