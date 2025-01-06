import '../../class/models/class_model.dart';
import '../../principal/models/principal_model.dart';
import '../../teacher/models/teacher_model.dart';

class SchoolModel {
  final String schoolId;
  final String name;
  final String address;
  final DateTime createdDate;
  final List<TeacherModel> teachers;
  final List<PrincipalModel> principals;
  final List<ClassModel> classes;

//<editor-fold desc="Data Methods">
  const SchoolModel({
    required this.schoolId,
    required this.name,
    required this.address,
    required this.createdDate,
    required this.teachers,
    required this.principals,
    required this.classes,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchoolModel &&
          runtimeType == other.runtimeType &&
          schoolId == other.schoolId &&
          name == other.name &&
          address == other.address &&
          createdDate == other.createdDate &&
          teachers == other.teachers &&
          principals == other.principals &&
          classes == other.classes);

  @override
  int get hashCode =>
      schoolId.hashCode ^
      name.hashCode ^
      address.hashCode ^
      createdDate.hashCode ^
      teachers.hashCode ^
      principals.hashCode ^
      classes.hashCode;

  @override
  String toString() {
    return 'SchoolModel{' +
        ' schoolId: $schoolId,' +
        ' name: $name,' +
        ' address: $address,' +
        ' createdDate: $createdDate,' +
        ' teachers: $teachers,' +
        ' principals: $principals,' +
        ' classes: $classes,' +
        '}';
  }

  SchoolModel copyWith({
    String? schoolId,
    String? name,
    String? address,
    DateTime? createdDate,
    List<TeacherModel>? teachers,
    List<PrincipalModel>? principals,
    List<ClassModel>? classes,
  }) {
    return SchoolModel(
      schoolId: schoolId ?? this.schoolId,
      name: name ?? this.name,
      address: address ?? this.address,
      createdDate: createdDate ?? this.createdDate,
      teachers: teachers ?? this.teachers,
      principals: principals ?? this.principals,
      classes: classes ?? this.classes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'schoolId': this.schoolId,
      'name': this.name,
      'address': this.address,
      'createdDate': this.createdDate,
      'teachers': this.teachers,
      'principals': this.principals,
      'classes': this.classes,
    };
  }

  factory SchoolModel.fromMap(Map<String, dynamic> map) {
    return SchoolModel(
      schoolId: map['schoolId'] as String,
      name: map['name'] as String,
      address: map['address'] as String,
      createdDate: map['createdDate'] as DateTime,
      teachers: map['teachers'] as List<TeacherModel>,
      principals: map['principals'] as List<PrincipalModel>,
      classes: map['classes'] as List<ClassModel>,
    );
  }

//</editor-fold>
}