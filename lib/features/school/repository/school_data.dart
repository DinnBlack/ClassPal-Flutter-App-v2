import '../../class/repository/class_data.dart';
import '../../principal/repository/principal_data.dart';
import '../../teacher/repository/teacher_data.dart';
import '../models/school_model.dart';

List<SchoolModel> sampleSchool_1 = [
  SchoolModel(
    id: 'SCH001',
    name: 'Tiểu học A Long Bình',
    address: 'Thị Trấn Long bình, Huyện An Phú, Tỉnh An Giang',
    phoneNumber: '0123456789',
    avatarUrl: 'https://i.pravatar.cc/150?img=57',
    creatorId: 'U001',
    createdAt: DateTime(2020, 5, 20),
    updatedAt: DateTime(2020, 5, 20),
  ),
  SchoolModel(
    id: 'SCH002',
    name: 'Tiểu học Quốc Thái',
    address: 'Xã Quốc Thái, Huyện An Phú, Tỉnh An Giang',
    phoneNumber: '0123456789',
    avatarUrl: 'https://i.pravatar.cc/150?img=57',
    creatorId: 'U001',
    createdAt: DateTime(2020, 5, 20),
    updatedAt: DateTime(2020, 5, 20),
  ),
];
