enum RepeatType { none, daily, weekly, monthly }

class ScheduleModel {
  String title;
  String note;
  DateTime startDate;
  DateTime endDate;
  DateTime startTime;
  DateTime endTime;
  RepeatType repeatType;
  DateTime? repeatEndDate;
  String color;

//<editor-fold desc="Data Methods">
  ScheduleModel({
    required this.title,
    required this.note,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.repeatType,
    this.repeatEndDate,
    required this.color,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleModel &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          note == other.note &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          repeatType == other.repeatType &&
          repeatEndDate == other.repeatEndDate &&
          color == other.color);

  @override
  int get hashCode =>
      title.hashCode ^
      note.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      repeatType.hashCode ^
      repeatEndDate.hashCode ^
      color.hashCode;

  @override
  String toString() {
    return 'ScheduleModel{' +
        ' title: $title,' +
        ' note: $note,' +
        ' startDate: $startDate,' +
        ' endDate: $endDate,' +
        ' startTime: $startTime,' +
        ' endTime: $endTime,' +
        ' repeatType: $repeatType,' +
        ' repeatEndDate: $repeatEndDate,' +
        ' color: $color,' +
        '}';
  }

  ScheduleModel copyWith({
    String? title,
    String? note,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? startTime,
    DateTime? endTime,
    RepeatType? repeatType,
    DateTime? repeatEndDate,
    String? color,
  }) {
    return ScheduleModel(
      title: title ?? this.title,
      note: note ?? this.note,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      repeatType: repeatType ?? this.repeatType,
      repeatEndDate: repeatEndDate ?? this.repeatEndDate,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': this.title,
      'note': this.note,
      'startDate': this.startDate,
      'endDate': this.endDate,
      'startTime': this.startTime,
      'endTime': this.endTime,
      'repeatType': this.repeatType,
      'repeatEndDate': this.repeatEndDate,
      'color': this.color,
    };
  }

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      title: map['title'] as String,
      note: map['note'] as String,
      startDate: map['startDate'] as DateTime,
      endDate: map['endDate'] as DateTime,
      startTime: map['startTime'] as DateTime,
      endTime: map['endTime'] as DateTime,
      repeatType: map['repeatType'] as RepeatType,
      repeatEndDate: map['repeatEndDate'] as DateTime,
      color: map['color'] as String,
    );
  }

//</editor-fold>
}