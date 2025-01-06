import '../models/user_model.dart';

List<UserModel> users = [
  UserModel(
    userId: 'U001',
    name: 'Alice Johnson',
    email: 'alice.johnson@example.com',
    phoneNumber: '1234567890',
    password: 'Alice@123',
    schoolIds: ['SCH001'],
    classIds: ['class_001'],
  ),
  UserModel(
    userId: 'U002',
    name: 'Bob Smith',
    email: 'bob.smith@example.com',
    phoneNumber: '1987654321',
    password: 'Bob@2023',
    schoolIds: ['school_002'],
    classIds: ['class_002'],
  ),
  UserModel(
    userId: 'U003',
    name: 'Charlie Brown',
    email: 'charlie.brown@example.com',
    phoneNumber: '1122334455',
    password: 'Charlie!2023',
    schoolIds: ['school_003'],
    classIds: ['class_003'],
  ),
  UserModel(
    userId: 'U004',
    name: 'Diana Prince',
    email: 'diana.prince@example.com',
    phoneNumber: '2233445566',
    password: 'Diana*123',
    schoolIds: ['school_001'],
    classIds: ['class_001'],
  ),
  UserModel(
    userId: 'U005',
    name: 'Ethan Hunt',
    email: 'ethan.hunt@example.com',
    phoneNumber: '3344556677',
    password: 'Ethan@007',
    schoolIds: ['school_002'],
    classIds: ['class_002'],
  ),
];