import 'package:classpal_flutter_app/features/school/views/school_create_screen.dart';
import 'package:classpal_flutter_app/features/school/views/school_create_screen.dart';
import 'package:flutter/material.dart';

import '../../features/auth/views/login_screen.dart';
import '../../features/auth/views/register_screen.dart';
import '../../features/auth/views/select_role_screen.dart';
import '../../features/class/views/class_create_screen.dart';
import '../../features/class/views/class_join_screen.dart';
import '../../features/class/views/class_screen.dart';
import '../../features/school/views/school_join_screen.dart';
import '../../features/school/views/school_screen.dart';
import '../../features/student/views/student_list_screen.dart';
import '../../shared/main_screen.dart';

Route<dynamic> routes(RouteSettings settings) {
  switch (settings.name) {

    // Authentication
    case LoginScreen.route:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case RegisterScreen.route:
      return MaterialPageRoute(builder: (context) => const RegisterScreen());
    case SelectRoleScreen.route:
      return MaterialPageRoute(builder: (context) => const SelectRoleScreen());

    // School
    case SchoolScreen.route:
      return MaterialPageRoute(builder: (context) => const SchoolScreen());
    case SchoolCreateScreen.route:
      return MaterialPageRoute(builder: (context) => const SchoolCreateScreen());
    case SchoolJoinScreen.route:
      return MaterialPageRoute(builder: (context) => const SchoolJoinScreen());

    // Class
    case ClassScreen.route:
      return MaterialPageRoute(builder: (context) => const ClassScreen());
    case ClassCreateScreen.route:
      final args = settings.arguments as Map<String, dynamic>?;
      final isClassCreateFirst = args?['isClassCreateFirst'] ?? false;
      return MaterialPageRoute(
        builder: (context) => ClassCreateScreen(isClassCreateFirst: isClassCreateFirst),
      );
    case ClassJoinScreen.route:
      return MaterialPageRoute(builder: (context) => const ClassJoinScreen());

    // Student
    case StudentListScreen.route:
      return MaterialPageRoute(builder: (context) => const StudentListScreen());

    // Default
    default:
      return MaterialPageRoute(builder: (context) => const MainScreen());
  }
}
