class GroupModel {
  final String id;
  final String classId;
  final String name;
  final String? description;
  final List<String> memberIds;
  final String createdBy;
  final DateTime updatedAt;
  final DateTime createdAt;

//<editor-fold desc="Data Methods">
  const GroupModel({
    required this.id,
    required this.classId,
    required this.name,
    this.description,
    required this.memberIds,
    required this.createdBy,
    required this.updatedAt,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          classId == other.classId &&
          name == other.name &&
          description == other.description &&
          memberIds == other.memberIds &&
          createdBy == other.createdBy &&
          updatedAt == other.updatedAt &&
          createdAt == other.createdAt);

  @override
  int get hashCode =>
      id.hashCode ^
      classId.hashCode ^
      name.hashCode ^
      description.hashCode ^
      memberIds.hashCode ^
      createdBy.hashCode ^
      updatedAt.hashCode ^
      createdAt.hashCode;

  @override
  String toString() {
    return 'GroupModel{' +
        ' id: $id,' +
        ' classId: $classId,' +
        ' name: $name,' +
        ' description: $description,' +
        ' memberIds: $memberIds,' +
        ' createdBy: $createdBy,' +
        ' updatedAt: $updatedAt,' +
        ' createdAt: $createdAt,' +
        '}';
  }

  GroupModel copyWith({
    String? id,
    String? classId,
    String? name,
    String? description,
    List<String>? memberIds,
    String? createdBy,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return GroupModel(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      name: name ?? this.name,
      description: description ?? this.description,
      memberIds: memberIds ?? this.memberIds,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'classId': this.classId,
      'name': this.name,
      'description': this.description,
      'memberIds': this.memberIds,
      'createdBy': this.createdBy,
      'updatedAt': this.updatedAt,
      'createdAt': this.createdAt,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['_id']?.toString() ?? '',
      classId: map['classId']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString(),
      memberIds: (map['memberIds'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      createdBy: map['createdBy']?.toString() ?? '',
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }


//</editor-fold>
}