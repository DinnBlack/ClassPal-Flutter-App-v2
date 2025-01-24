class SubjectModel {
  final String _id;
  final String creatorId;
  final String avatarUrl;
  final String name;
  final String description;
  final String teacherName;
  final DateTime createdAt;
  final DateTime updatedAt;

//<editor-fold desc="Data Methods">
  const SubjectModel({
    required this.creatorId,
    required this.avatarUrl,
    required this.name,
    required this.description,
    required this.teacherName,
    required this.createdAt,
    required this.updatedAt,
    required String id,
  }) : _id = id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubjectModel &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          creatorId == other.creatorId &&
          avatarUrl == other.avatarUrl &&
          name == other.name &&
          description == other.description &&
          teacherName == other.teacherName &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt);

  @override
  int get hashCode =>
      _id.hashCode ^
      creatorId.hashCode ^
      avatarUrl.hashCode ^
      name.hashCode ^
      description.hashCode ^
      teacherName.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() {
    return 'SubjectModel{' +
        ' _id: $_id,' +
        ' creatorId: $creatorId,' +
        ' avatarUrl: $avatarUrl,' +
        ' name: $name,' +
        ' description: $description,' +
        ' teacherName: $teacherName,' +
        ' createdAt: $createdAt,' +
        ' updatedAt: $updatedAt,' +
        '}';
  }

  SubjectModel copyWith({
    String? id,
    String? creatorId,
    String? avatarUrl,
    String? name,
    String? description,
    String? teacherName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubjectModel(
      id: id ?? this._id,
      creatorId: creatorId ?? this.creatorId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      name: name ?? this.name,
      description: description ?? this.description,
      teacherName: teacherName ?? this.teacherName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': this._id,
      'creatorId': this.creatorId,
      'avatarUrl': this.avatarUrl,
      'name': this.name,
      'description': this.description,
      'teacherName': this.teacherName,
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['_id'] as String,
      creatorId: map['creatorId'] as String,
      avatarUrl: map['avatarUrl'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      teacherName: map['teacherName'] as String,
      createdAt: map['createdAt'] as DateTime,
      updatedAt: map['updatedAt'] as DateTime,
    );
  }

//</editor-fold>
}