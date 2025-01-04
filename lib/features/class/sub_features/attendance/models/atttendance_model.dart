class AttendanceModel {
  String studentId;
  bool isPresent;

//<editor-fold desc="Data Methods">
  AttendanceModel({
    required this.studentId,
    required this.isPresent,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceModel &&
          runtimeType == other.runtimeType &&
          studentId == other.studentId &&
          isPresent == other.isPresent);

  @override
  int get hashCode => studentId.hashCode ^ isPresent.hashCode;

  @override
  String toString() {
    return 'AttendanceModel{' +
        ' studentId: $studentId,' +
        ' isPresent: $isPresent,' +
        '}';
  }

  AttendanceModel copyWith({
    String? studentId,
    bool? isPresent,
  }) {
    return AttendanceModel(
      studentId: studentId ?? this.studentId,
      isPresent: isPresent ?? this.isPresent,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': this.studentId,
      'isPresent': this.isPresent,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      studentId: map['studentId'] as String,
      isPresent: map['isPresent'] as bool,
    );
  }

//</editor-fold>
}