class SchoolModel {
  final String id;
  final String name;
  final String? address;
  final String? phoneNumber;
  final String avatarUrl;
  final String creatorId;
  final DateTime updatedAt;
  final DateTime createdAt;

//<editor-fold desc="Data Methods">
  const SchoolModel({
    required this.id,
    required this.name,
    this.address,
    this.phoneNumber,
    required this.avatarUrl,
    required this.creatorId,
    required this.updatedAt,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchoolModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          address == other.address &&
          phoneNumber == other.phoneNumber &&
          avatarUrl == other.avatarUrl &&
          creatorId == other.creatorId &&
          updatedAt == other.updatedAt &&
          createdAt == other.createdAt);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      address.hashCode ^
      phoneNumber.hashCode ^
      avatarUrl.hashCode ^
      creatorId.hashCode ^
      updatedAt.hashCode ^
      createdAt.hashCode;

  @override
  String toString() {
    return 'SchoolModel{' +
        ' id: $id,' +
        ' name: $name,' +
        ' address: $address,' +
        ' phoneNumber: $phoneNumber,' +
        ' avatarUrl: $avatarUrl,' +
        ' creatorId: $creatorId,' +
        ' updatedAt: $updatedAt,' +
        ' createdAt: $createdAt,' +
        '}';
  }

  SchoolModel copyWith({
    String? id,
    String? name,
    String? address,
    String? phoneNumber,
    String? avatarUrl,
    String? creatorId,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return SchoolModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      creatorId: creatorId ?? this.creatorId,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'creatorId': creatorId,
      'updatedAt': updatedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }


  factory SchoolModel.fromMap(Map<String, dynamic> map) {
    return SchoolModel(
      id: map['_id']?.toString() ?? '',
      // Nếu null, thay thế bằng chuỗi rỗng
      name: map['name']?.toString() ?? '',
      address: map['address']?.toString(),
      // Có thể null
      phoneNumber: map['phoneNumber']?.toString(),
      // Có thể null
      avatarUrl: map['avatarUrl']?.toString() ?? '',
      creatorId: map['creatorId']?.toString() ?? '',
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'].toString())
          : DateTime.now(),
      // Nếu null, dùng thời gian hiện tại
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'].toString())
          : DateTime.now(),
    );
  }

//</editor-fold>
}
