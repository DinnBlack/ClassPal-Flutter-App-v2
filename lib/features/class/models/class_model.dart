import '../../student/models/student_model.dart';
import '../../teacher/models/teacher_model.dart';
import '../sub_features/attendance/models/atttendance_model.dart';
import '../sub_features/schedule/models/schedule_model.dart';

class ClassModel {
  String className;
  List<TeacherModel> teachers;
  DateTime creationDate;
  Map<DateTime, List<AttendanceModel>> attendanceRecords;
  List<StudentModel> students;
  List<ScheduleModel> schedule;

//<editor-fold desc="Data Methods">
  ClassModel({
    required this.className,
    required this.teachers,
    required this.creationDate,
    required this.attendanceRecords,
    required this.students,
    required this.schedule,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassModel &&
          runtimeType == other.runtimeType &&
          className == other.className &&
          teachers == other.teachers &&
          creationDate == other.creationDate &&
          attendanceRecords == other.attendanceRecords &&
          students == other.students &&
          schedule == other.schedule);

  @override
  int get hashCode =>
      className.hashCode ^
      teachers.hashCode ^
      creationDate.hashCode ^
      attendanceRecords.hashCode ^
      students.hashCode ^
      schedule.hashCode;

  @override
  String toString() {
    return 'ClassModel{' +
        ' className: $className,' +
        ' teachers: $teachers,' +
        ' creationDate: $creationDate,' +
        ' attendanceRecords: $attendanceRecords,' +
        ' students: $students,' +
        ' schedule: $schedule,' +
        '}';
  }

  ClassModel copyWith({
    String? className,
    List<TeacherModel>? teachers,
    DateTime? creationDate,
    Map<DateTime, List<AttendanceModel>>? attendanceRecords,
    List<StudentModel>? students,
    List<ScheduleModel>? schedule,
  }) {
    return ClassModel(
      className: className ?? this.className,
      teachers: teachers ?? this.teachers,
      creationDate: creationDate ?? this.creationDate,
      attendanceRecords: attendanceRecords ?? this.attendanceRecords,
      students: students ?? this.students,
      schedule: schedule ?? this.schedule,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'className': this.className,
      'teachers': this.teachers,
      'creationDate': this.creationDate,
      'attendanceRecords': this.attendanceRecords,
      'students': this.students,
      'schedule': this.schedule,
    };
  }

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      className: map['className'] as String,
      teachers: map['teachers'] as List<TeacherModel>,
      creationDate: map['creationDate'] as DateTime,
      attendanceRecords:
          map['attendanceRecords'] as Map<DateTime, List<AttendanceModel>>,
      students: map['students'] as List<StudentModel>,
      schedule: map['schedule'] as List<ScheduleModel>,
    );
  }

//</editor-fold>
}

