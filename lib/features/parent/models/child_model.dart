class ChildModel {
  final String id;
  final String displayName;
  final String avatarUrl;
  final String className;
  final String classId;

//<editor-fold desc="Data Methods">
  const ChildModel({
    required this.id,
    required this.displayName,
    required this.avatarUrl,
    required this.className,
    required this.classId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChildModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          displayName == other.displayName &&
          avatarUrl == other.avatarUrl &&
          className == other.className &&
          classId == other.classId);

  @override
  int get hashCode =>
      id.hashCode ^
      displayName.hashCode ^
      avatarUrl.hashCode ^
      className.hashCode ^
      classId.hashCode;

  @override
  String toString() {
    return 'ChildModel{' +
        ' id: $id,' +
        ' displayName: $displayName,' +
        ' avatarUrl: $avatarUrl,' +
        ' className: $className,' +
        ' classId: $classId,' +
        '}';
  }

  ChildModel copyWith({
    String? id,
    String? displayName,
    String? avatarUrl,
    String? className,
    String? classId,
  }) {
    return ChildModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      className: className ?? this.className,
      classId: classId ?? this.classId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'displayName': this.displayName,
      'avatarUrl': this.avatarUrl,
      'className': this.className,
      'classId': this.classId,
    };
  }

  factory ChildModel.fromMap(Map<String, dynamic> map) {
    return ChildModel(
      id: map['id'] as String,
      displayName: map['displayName'] as String,
      avatarUrl: map['avatarUrl'] as String,
      className: map['className'] as String,
      classId: map['classId'] as String,
    );
  }

//</editor-fold>
}