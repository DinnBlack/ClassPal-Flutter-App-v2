import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:classpal_flutter_app/features/school/bloc/school_bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/config/app_routes.dart';
import 'core/config/app_themes.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/class/bloc/class_bloc.dart';
import 'features/class/sub_features/grade/bloc/grade_bloc.dart';
import 'features/class/sub_features/roll_call/bloc/roll_call_bloc.dart';
import 'features/class/sub_features/subject/bloc/subject_bloc.dart';
import 'features/invitation/bloc/invitation_bloc.dart';
import 'features/invitation/views/invitation_screen.dart';
import 'features/parent/bloc/parent_bloc.dart';
import 'features/post/bloc/post_bloc.dart';
import 'features/post/sub_feature/comment/bloc/comment_bloc.dart';
import 'features/profile/bloc/profile_bloc.dart';
import 'features/student/bloc/student_bloc.dart';
import 'features/student/sub_features/group/bloc/group_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'features/teacher/bloc/teacher_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/config/platform/platform_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi', null);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  timeago.setLocaleMessages('vi', timeago.ViMessages());

  // Cấu hình URL Strategy cho Web
  configureApp();

  runApp(
    MyApp(isLoggedIn: isLoggedIn),
  );
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLinks appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;
  Uri? _pendingDeepLink;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = MyAppRouter().router;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_pendingDeepLink != null) {
      Future.microtask(() => _handleDeepLink(_pendingDeepLink!));
      _pendingDeepLink = null;
    }
  }

  void _handleDeepLink(Uri uri) {
    print("Deep link nhận được: $uri");

    if (uri.host == "classpal.pages.dev") {
      if (uri.pathSegments.isNotEmpty &&
          uri.pathSegments.first == "invitation" &&
          uri.pathSegments.length >= 2) {
        String token = uri.pathSegments[1];

        // Chờ xử lý UI
        Future.delayed(Duration.zero, () {
          if (navigatorKey.currentState != null) {
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => InvitationScreen(token: token),
              ),
            );
          }
        });
      } else {
        print("Đường dẫn không hợp lệ!");
      }
    } else {
      print("Host hoặc port không đúng!");
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_pendingDeepLink != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleDeepLink(_pendingDeepLink!);
        _pendingDeepLink = null;
      });
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<SchoolBloc>(create: (context) => SchoolBloc()),
        BlocProvider<ClassBloc>(create: (context) => ClassBloc()),
        BlocProvider<StudentBloc>(create: (context) => StudentBloc()),
        BlocProvider<GroupBloc>(create: (context) => GroupBloc()),
        BlocProvider<SubjectBloc>(create: (context) => SubjectBloc()),
        BlocProvider<RollCallBloc>(create: (context) => RollCallBloc()),
        BlocProvider<PostBloc>(create: (context) => PostBloc()),
        BlocProvider<GradeBloc>(create: (context) => GradeBloc()),
        BlocProvider<TeacherBloc>(create: (context) => TeacherBloc()),
        BlocProvider<InvitationBloc>(create: (context) => InvitationBloc()),
        BlocProvider<CommentBloc>(create: (context) => CommentBloc()),
        BlocProvider<ParentBloc>(create: (context) => ParentBloc()),
      ],
      child: MaterialApp.router(
        title: 'ClassPal',
        debugShowCheckedModeBanner: false,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: lightTheme,
        themeMode: ThemeMode.system,
        routerConfig: _router,
      ),
    );
  }
}
