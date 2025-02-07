import 'social_media_account_model.dart';

enum USER_ROLE { ADMIN, USER }

enum USER_STATUS { ACTIVE, INACTIVE }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String? phoneNumber;
  final String avatarUrl;
  final int role;
  final int status;
  final List<SocialMediaAccount> socialMediaAccounts;
  final DateTime createdAt;
  final DateTime updatedAt;

//<editor-fold desc="Data Methods">
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.phoneNumber,
    required this.avatarUrl,
    required this.role,
    required this.status,
    required this.socialMediaAccounts,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          password == other.password &&
          phoneNumber == other.phoneNumber &&
          avatarUrl == other.avatarUrl &&
          role == other.role &&
          status == other.status &&
          socialMediaAccounts == other.socialMediaAccounts &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      password.hashCode ^
      phoneNumber.hashCode ^
      avatarUrl.hashCode ^
      role.hashCode ^
      status.hashCode ^
      socialMediaAccounts.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() {
    return 'UserModel{' +
        ' id: $id,' +
        ' name: $name,' +
        ' email: $email,' +
        ' password: $password,' +
        ' phoneNumber: $phoneNumber,' +
        ' avatarUrl: $avatarUrl,' +
        ' role: $role,' +
        ' status: $status,' +
        ' socialMediaAccounts: $socialMediaAccounts,' +
        ' createdAt: $createdAt,' +
        ' updatedAt: $updatedAt,' +
        '}';
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? phoneNumber,
    String? avatarUrl,
    int? role,
    int? status,
    List<SocialMediaAccount>? socialMediaAccounts,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      socialMediaAccounts: socialMediaAccounts ?? this.socialMediaAccounts,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'role': role,
      'status': status,
      'socialMediaAccounts': socialMediaAccounts.map((e) => e.toMap()).toList(), // Convert list to map
      'createdAt': createdAt.toIso8601String(),  // Convert DateTime to String
      'updatedAt': updatedAt.toIso8601String(),  // Convert DateTime to String
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    var socialMediaList = (map['socialMediaAccounts'] as List<dynamic>)
        .map((item) => SocialMediaAccount.fromMap(item))
        .toList();

    return UserModel(
      id: map['_id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] ?? '',
      phoneNumber: map['phoneNumber'] as String?,
      avatarUrl: map['avatarUrl'] as String,
      role: map['role'] as int,
      status: map['status'] as int,
      socialMediaAccounts: socialMediaList,  // Use the mapped list
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

//</editor-fold>
}
