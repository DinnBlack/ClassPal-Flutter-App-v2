class PrincipalModel {
  final String userId;
  final String name;
  final bool isAccepted;

//<editor-fold desc="Data Methods">
  const PrincipalModel({
    required this.userId,
    required this.name,
    required this.isAccepted,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrincipalModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          name == other.name &&
          isAccepted == other.isAccepted);

  @override
  int get hashCode => userId.hashCode ^ name.hashCode ^ isAccepted.hashCode;

  @override
  String toString() {
    return 'PrincipalModel{' +
        ' userId: $userId,' +
        ' name: $name,' +
        ' isAccepted: $isAccepted,' +
        '}';
  }

  PrincipalModel copyWith({
    String? userId,
    String? name,
    bool? isAccepted,
  }) {
    return PrincipalModel(
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

  factory PrincipalModel.fromMap(Map<String, dynamic> map) {
    return PrincipalModel(
      userId: map['userId'] as String,
      name: map['name'] as String,
      isAccepted: map['isAccepted'] as bool,
    );
  }

//</editor-fold>
}
