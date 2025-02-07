import '../../../../profile/model/profile_model.dart';
import 'group_model.dart';

class GroupWithStudentsModel {
  final GroupModel group;
  final List<ProfileModel> students;

//<editor-fold desc="Data Methods">
  const GroupWithStudentsModel({
    required this.group,
    required this.students,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupWithStudentsModel &&
          runtimeType == other.runtimeType &&
          group == other.group &&
          students == other.students);

  @override
  int get hashCode => group.hashCode ^ students.hashCode;

  @override
  String toString() {
    return 'GroupWithStudentsModel{' +
        ' group: $group,' +
        ' students: $students,' +
        '}';
  }

  GroupWithStudentsModel copyWith({
    GroupModel? group,
    List<ProfileModel>? students,
  }) {
    return GroupWithStudentsModel(
      group: group ?? this.group,
      students: students ?? this.students,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'group': this.group,
      'students': this.students,
    };
  }

  factory GroupWithStudentsModel.fromMap(Map<String, dynamic> map) {
    return GroupWithStudentsModel(
      group: map['group'] as GroupModel,
      students: map['students'] as List<ProfileModel>,
    );
  }

//</editor-fold>
}