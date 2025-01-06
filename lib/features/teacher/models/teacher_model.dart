class TeacherModel {
  final String userId;
  final String name;
  final bool isAccepted;

//<editor-fold desc="Data Methods">
  const TeacherModel({
    required this.userId,
    required this.name,
    required this.isAccepted,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TeacherModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          name == other.name &&
          isAccepted == other.isAccepted);

  @override
  int get hashCode => userId.hashCode ^ name.hashCode ^ isAccepted.hashCode;

  @override
  String toString() {
    return 'TeacherModel{' +
        ' userId: $userId,' +
        ' name: $name,' +
        ' isAccepted: $isAccepted,' +
        '}';
  }

  TeacherModel copyWith({
    String? userId,
    String? name,
    bool? isAccepted,
  }) {
    return TeacherModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      isAccepted: isAccepted ?? this.isAccepted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'name': this.name,
      'isAccepted': this.isAccepted,
    };
  }

  factory TeacherModel.fromMap(Map<String, dynamic> map) {
    return TeacherModel(
      userId: map['userId'] as String,
      name: map['name'] as String,
      isAccepted: map['isAccepted'] as bool,
    );
  }

//</editor-fold>
}
