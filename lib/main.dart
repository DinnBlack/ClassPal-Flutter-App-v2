import 'dart:async';
import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:classpal_flutter_app/features/auth/views/register_screen.dart';
import 'package:classpal_flutter_app/features/school/bloc/school_bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'core/config/app_routes.dart';
import 'core/config/app_themes.dart';
import 'features/auth/views/login_screen.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/views/select_role_screen.dart';
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
import 'package:timeago/src/messages/vi_messages.dart';
import 'features/teacher/bloc/teacher_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  timeago.setLocaleMessages('vi', ViMessages());

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
  StreamSubscription? _sub;
  String? _pendingDeepLink;
  bool _isAppReady = false;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _initDeepLink();
  }

  Future<void> _initDeepLink() async {
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        setState(() {
          _pendingDeepLink = initialLink;
        });
      }

      _sub = linkStream.listen((String? link) {
        if (link != null) {
          setState(() {
            _pendingDeepLink = link;
          });
        }
      });
    } catch (e) {
      print('Lỗi lấy deep link: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_pendingDeepLink != null) {
      Future.microtask(() => _handleDeepLink(_pendingDeepLink!));
      _pendingDeepLink = null;
    }
  }

  void _handleDeepLink(String link) {
    print("Deep link nhận được: $link");
    Uri uri = Uri.parse(link);

    if (uri.host == "cpserver.amrakk.rest" && uri.pathSegments.length == 2 && uri.pathSegments.first == "invitation") {
      String token = uri.pathSegments[1];

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.microtask(() {
          if (navigatorKey.currentState != null) {
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => InvitationScreen(token: token),
              ),
            );
          }
        });
      });
    } else {
      print("Không tìm thấy đường dẫn hợp lệ!");
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
      child: MaterialApp(
        navigatorKey: navigatorKey,
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
        initialRoute:
            widget.isLoggedIn ? SelectRoleScreen.route : LoginScreen.route,
      ),
    );
  }
}
