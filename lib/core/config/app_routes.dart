import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/views/login_screen.dart';
import '../../features/auth/views/register_screen.dart';
import '../../features/auth/views/forgot_password_screen.dart';
import '../../features/auth/views/reset_password_screen.dart';
import '../../features/auth/views/select_role_screen.dart';
import '../../features/auth/views/otp_screen.dart';
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
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String otp = '/auth/otp';
  static const String resetPassword = '/auth/reset-password';
  static const String selectRole = '/auth/select-role';

  // Home with dynamic role
  static const String home = '/home/:role';

  // School
  static const String school = '/home/school';
  static const String schoolCreate = '/home/school/create';
  static const String schoolJoin = '/home/school/join';

  // Class
  static const String classScreen = '/home/class';
  static const String classCreate = '/home/class/create';
  static const String classJoin = '/home/class/join';

  // Student
  static const String studentList = '/home/student/list';
  static const String studentCreate = '/home/student/create';

  // Invitation
  static const String invitation = '/invitation/:token';
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(bool isLoggedIn) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation:
        isLoggedIn ? RouteConstants.selectRole : RouteConstants.login,
    routes: [
      // Authentication
      GoRoute(
          path: RouteConstants.login,
          name: 'login',
          builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: RouteConstants.register,
          name: 'register',
          builder: (context, state) => const RegisterScreen()),
      GoRoute(
          path: RouteConstants.forgotPassword,
          name: 'forgotPassword',
          builder: (context, state) =>
              ForgotPasswordScreen(email: state.extra as String? ?? '')),
      GoRoute(
          path: RouteConstants.otp,
          name: 'otp',
          builder: (context, state) => OtpScreen(
              email: (state.extra as Map<String, dynamic>?)?['email'])),
      GoRoute(
          path: RouteConstants.resetPassword,
          name: 'resetPassword',
          builder: (context, state) => ResetPasswordScreen(
              email: (state.extra as Map<String, dynamic>?)?['email'],
              otp: (state.extra as Map<String, dynamic>?)?['otp'])),
      GoRoute(
          path: RouteConstants.selectRole,
          name: 'selectRole',
          builder: (context, state) => const SelectRoleScreen()),

      // Home (Dynamic Role)
      GoRoute(
        path: RouteConstants.home,
        name: 'home',
        builder: (context, state) {
          // Lấy tham số role từ URL
          final role = state.pathParameters['role']!;
          return MainScreen(role: role);
        },
      ),

      // School
      GoRoute(
          path: RouteConstants.school,
          name: 'school',
          builder: (context, state) => SchoolScreen(
              school: (state.extra as Map<String, dynamic>?)?['school'])),
      GoRoute(
          path: RouteConstants.schoolCreate,
          name: 'schoolCreate',
          builder: (context, state) => const SchoolCreateScreen()),
      GoRoute(
          path: RouteConstants.schoolJoin,
          name: 'schoolJoin',
          builder: (context, state) => const SchoolJoinScreen()),

      // Class
      GoRoute(
          path: RouteConstants.classScreen,
          name: 'classScreen',
          builder: (context, state) => ClassScreen(
              currentClass:
                  (state.extra as Map<String, dynamic>?)?['currentClass'])),
      GoRoute(
          path: RouteConstants.classCreate,
          name: 'classCreate',
          builder: (context, state) => const ClassCreateScreen()),
      GoRoute(
          path: RouteConstants.classJoin,
          name: 'classJoin',
          builder: (context, state) => const ClassJoinScreen()),

      // Student
      GoRoute(
          path: RouteConstants.studentList,
          name: 'studentList',
          builder: (context, state) => const StudentListScreen()),
      GoRoute(
          path: RouteConstants.studentCreate,
          name: 'studentCreate',
          builder: (context, state) => const StudentCreateScreen()),

      // Invitation
      GoRoute(
          path: RouteConstants.invitation,
          name: 'invitation',
          builder: (context, state) =>
              InvitationScreen(token: state.pathParameters['token']!)),

      // Default route
      GoRoute(
          path: '/',
          name: 'default',
          builder: (context, state) => MainScreen(
              role: (state.extra as Map<String, dynamic>?)?['role'] ??
                  'default')),
    ],
  );
}
