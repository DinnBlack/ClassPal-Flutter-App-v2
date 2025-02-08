import 'package:classpal_flutter_app/features/school/bloc/school_bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/config/app_routes.dart';
import 'core/config/app_themes.dart';
import 'features/auth/views/login_screen.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/views/select_role_screen.dart';
import 'features/class/bloc/class_bloc.dart';
import 'features/class/sub_features/subject/bloc/subject_bloc.dart';
import 'features/profile/bloc/profile_bloc.dart';
import 'features/student/bloc/student_bloc.dart';
import 'features/student/sub_features/group/bloc/group_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<SchoolBloc>(
          create: (context) => SchoolBloc(),
        ),
        BlocProvider<ClassBloc>(
          create: (context) => ClassBloc(),
        ),
        BlocProvider<StudentBloc>(
          create: (context) => StudentBloc(),
        ),BlocProvider<GroupBloc>(
          create: (context) => GroupBloc(),
        ),BlocProvider<SubjectBloc>(
          create: (context) => SubjectBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'ClassPal',
        debugShowCheckedModeBanner: false,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: lightTheme,
        localizationsDelegates: const [
          EasyDateTimelineLocalizations.delegate,
        ],
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        onGenerateRoute: routes,
        // Nếu đã đăng nhập, vào SelectRoleScreen, nếu chưa, vào LoginScreen
        initialRoute: isLoggedIn ? SelectRoleScreen.route : LoginScreen.route,
      ),
    );
  }
}

