import 'package:classpal_flutter_app/features/class/models/class_model.dart';
import 'package:classpal_flutter_app/features/school/models/school_model.dart';
import 'package:classpal_flutter_app/features/student/models/student_model.dart';
import 'package:flutter/material.dart';

import '../../features/auth/models/user_model.dart';
import '../../features/auth/views/forgot_password_screen.dart';
import '../../features/auth/views/login_screen.dart';
import '../../features/auth/views/register_screen.dart';
import '../../features/auth/views/reset_password_screen.dart';
import '../../features/auth/views/select_role_screen.dart';
import '../../features/class/views/class_create_screen.dart';
import '../../features/class/views/class_join_screen.dart';
import '../../features/class/views/class_screen.dart';
import '../../features/school/views/school_create_screen.dart';
import '../../features/school/views/school_join_screen.dart';
import '../../features/school/views/school_screen.dart';
import '../../features/student/views/student_create_screen.dart';
import '../../features/student/views/student_list_screen.dart';
import '../../shared/main_screen.dart';

Route<dynamic> routes(RouteSettings settings) {
  switch (settings.name) {
    // Authentication
    case LoginScreen.route:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case ForgotPasswordScreen.route:
      return MaterialPageRoute(builder: (context) => const ForgotPasswordScreen());
    case ResetPasswordScreen.route:
      final args = settings.arguments as Map<String, dynamic>?;
      final String email = args?['email'];
      final String otp = args?['otp'];
      return MaterialPageRoute(builder: (context) =>  ResetPasswordScreen(email: email, otp: otp,));
    case RegisterScreen.route:
      return MaterialPageRoute(builder: (context) => const RegisterScreen());
    case SelectRoleScreen.route:
      final args = settings.arguments as Map<String, dynamic>?;
      final UserModel user = args?['user'];
      return MaterialPageRoute(
          builder: (context) => SelectRoleScreen(
                user: user,
              ));

    // School
    case SchoolScreen.route:
      final args = settings.arguments as Map<String, dynamic>?;
      final SchoolModel school = args?['school'];
      return MaterialPageRoute(
          builder: (context) => SchoolScreen(
                school: school,
              ));
    case SchoolCreateScreen.route:
      return MaterialPageRoute(
          builder: (context) => const SchoolCreateScreen());
    case SchoolJoinScreen.route:
      return MaterialPageRoute(builder: (context) => const SchoolJoinScreen());

    // Class
    case ClassScreen.route:
      final args = settings.arguments as Map<String, dynamic>?;
      final ClassModel currentClass = args?['currentClass'];
      return MaterialPageRoute(
          builder: (context) => ClassScreen(
                currentClass: currentClass,
              ));
    case ClassCreateScreen.route:
      final args = settings.arguments as Map<String, dynamic>?;
      final isClassCreateFirst = args?['isClassCreateFirst'] ?? false;
      return MaterialPageRoute(
        builder: (context) =>
            ClassCreateScreen(isClassCreateFirst: isClassCreateFirst),
      );
    case ClassJoinScreen.route:
      return MaterialPageRoute(builder: (context) => const ClassJoinScreen());

    // Student
    case StudentListScreen.route:
      final args = settings.arguments as Map<String, dynamic>?;
      final students = args?['students'] as List<StudentModel>? ?? [];
      final isListView = args?['isListView'] as bool? ?? false;
      return MaterialPageRoute(
        builder: (context) => StudentListScreen(
          students: students,
          isListView: isListView,
        ),
      );
    case StudentCreateScreen.route:
      final args = settings.arguments as Map<String, dynamic>?;
      final students = args?['students'] as List<StudentModel>? ?? [];
      return MaterialPageRoute(
          builder: (context) => StudentCreateScreen(
                students: students,
              ));

// Default
    default:
      final args = settings.arguments as Map<String, dynamic>?;
      final UserModel user = args?['user'];
      final String role = args?['role'];

      return MaterialPageRoute(
        builder: (context) => MainScreen(
          user: user,
          role: role,
        ),
      );
  }
}
