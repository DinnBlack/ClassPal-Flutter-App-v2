
class SchoolModel {
  final String _id;
  final String name;
  final String? address;
  final String? phoneNumber;
  final String avatarUrl;
  final String creatorId;
  final DateTime updatedAt;
  final DateTime createdAt;

//<editor-fold desc="Data Methods">
  const SchoolModel({
    required this.name,
    this.address,
    this.phoneNumber,
    required this.avatarUrl,
    required this.creatorId,
    required this.updatedAt,
    required this.createdAt,
    required String id,
  }) : _id = id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchoolModel &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          name == other.name &&
          address == other.address &&
          phoneNumber == other.phoneNumber &&
          avatarUrl == other.avatarUrl &&
          creatorId == other.creatorId &&
          updatedAt == other.updatedAt &&
          createdAt == other.createdAt);

  @override
  int get hashCode =>
      _id.hashCode ^
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
        ' _id: $_id,' +
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
      id: id ?? this._id,
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
      '_id': this._id,
      'name': this.name,
      'address': this.address,
      'phoneNumber': this.phoneNumber,
      'avatarUrl': this.avatarUrl,
      'creatorId': this.creatorId,
      'updatedAt': this.updatedAt,
      'createdAt': this.createdAt,
    };
  }

  factory SchoolModel.fromMap(Map<String, dynamic> map) {
    return SchoolModel(
      id: map['_id'] as String,
      name: map['name'] as String,
      address: map['address'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      avatarUrl: map['avatarUrl'] as String,
      creatorId: map['creatorId'] as String,
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

//</editor-fold>
}