import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/views/login_screen.dart';
import '../../features/auth/views/register_screen.dart';
import '../../features/auth/views/forgot_password_screen.dart';
import '../../features/auth/views/reset_password_screen.dart';
import '../../features/auth/views/select_role_screen.dart';
import '../../features/auth/views/otp_screen.dart';
import '../../features/class/models/class_model.dart';
import '../../features/class/views/class_create_screen.dart';
import '../../features/class/views/class_join_screen.dart';
import '../../features/class/views/class_screen.dart';
import '../../features/invitation/views/invitation_screen.dart';
import '../../features/school/views/school_create_screen.dart';
import '../../features/school/views/school_join_screen.dart';
import '../../features/school/views/school_screen.dart';
import '../../features/student/views/student_create_screen.dart';
import '../../features/student/views/student_list_screen.dart';
import '../../shared/main_screen.dart';

class RouteConstants {
  // Authentication
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgot-password';
  static const String otp = 'otp';
  static const String resetPassword = 'reset-password';
  static const String selectRole = 'select-role';

  // Home with dynamic role
  static const String home = 'home';

  // School
  static const String school = 'school';
  static const String schoolCreate = 'school-create';
  static const String schoolJoin = 'school-join';

  // Class
  static const String classScreen = 'class';
  static const String classCreate = 'class-create';
  static const String classJoin = 'class-join';

  // Student
  static const String studentList = 'student-list';
  static const String studentCreate = 'student-create';

  // Invitation
  static const String invitation = 'invitation';
}

class MyAppRouter {
  late final GoRouter router = GoRouter(
    initialLocation: '/auth/login',
    routes: [
      // Authentication
      GoRoute(
        name: RouteConstants.login,
        path: '/auth/login',
        pageBuilder: (context, state) {
          return const MaterialPage(child: LoginScreen());
        },
      ),
      GoRoute(
        name: RouteConstants.register,
        path: '/auth/register',
        pageBuilder: (context, state) {
          return const MaterialPage(child: RegisterScreen());
        },
      ),
      GoRoute(
        name: RouteConstants.forgotPassword,
        path: '/auth/forgot-password',
        builder: (context, state) => ForgotPasswordScreen(
            email: (state.extra as Map<String, dynamic>?)?['email']),
      ),
      GoRoute(
          name: RouteConstants.otp,
          path: '/auth/otp',
          builder: (context, state) => OtpScreen(
              email: (state.extra as Map<String, dynamic>?)?['email'])),
      GoRoute(
          name: RouteConstants.resetPassword,
          path: '/auth/reset-password',
          builder: (context, state) => ResetPasswordScreen(
              email: (state.extra as Map<String, dynamic>?)?['email'],
              otp: (state.extra as Map<String, dynamic>?)?['otp'])),
      GoRoute(
          name: RouteConstants.selectRole,
          path: '/auth/select-role',
          builder: (context, state) => const SelectRoleScreen()),

      // Home (Dynamic Role)
      GoRoute(
        name: RouteConstants.home,
        path: '/home/:role',
        builder: (context, state) {
          final role = state.pathParameters['role']!;
          return MainScreen(role: role);
        },
      ),

      // School
      GoRoute(
          name: RouteConstants.school,
          path: '/home/school',
          builder: (context, state) => SchoolScreen(
              school: (state.extra as Map<String, dynamic>?)?['school'])),
      GoRoute(
          name: RouteConstants.schoolCreate,
          path: '/home/school/create',
          builder: (context, state) => const SchoolCreateScreen()),
      GoRoute(
          name: RouteConstants.schoolJoin,
          path: '/home/school/join',
          builder: (context, state) => const SchoolJoinScreen()),

      // Class
      GoRoute(
        name: RouteConstants.classScreen,
        path: '/home/class',
        builder: (context, state) {
          print(1);
          // Kiểm tra xem extra có null không
          final Map<String, dynamic>? extra =
              state.extra as Map<String, dynamic>?;

          print(extra);

          // Chuyển đổi Map sang ClassModel
          final currentClass = ClassModel.fromMap(extra!['currentClass']);

          // Debug thông tin
          print(currentClass); // Xem thông tin của currentClass để debug

          // Trả về ClassScreen với currentClass
          return ClassScreen(currentClass: currentClass);
        },
      ),
      GoRoute(
          name: RouteConstants.classCreate,
          path: '/home/class/create',
          builder: (context, state) => const ClassCreateScreen()),
      GoRoute(
          name: RouteConstants.classJoin,
          path: '/home/class/join',
          builder: (context, state) => const ClassJoinScreen()),

      // Student
      GoRoute(
          name: RouteConstants.studentList,
          path: '/home/student/list',
          builder: (context, state) => const StudentListScreen()),
      GoRoute(
          name: RouteConstants.studentCreate,
          path: '/home/student/create',
          builder: (context, state) => const StudentCreateScreen()),

      // Invitation
      GoRoute(
          name: RouteConstants.invitation,
          path: '/invitation/:token',
          builder: (context, state) =>
              InvitationScreen(token: state.pathParameters['token']!)),

      // Default route
      GoRoute(
          name: 'default',
          path: '/',
          builder: (context, state) => MainScreen(
              role: (state.extra as Map<String, dynamic>?)?['role'] ??
                  'default')),
    ],
  );
}
