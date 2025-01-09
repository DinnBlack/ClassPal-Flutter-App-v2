import 'package:classpal_flutter_app/features/school/bloc/school_bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/app_routes.dart';
import 'core/config/app_themes.dart';
import 'features/auth/views/login_screen.dart';
import 'features/auth/bloc/auth_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<SchoolBloc>(
          create: (context) => SchoolBloc(),
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
        initialRoute: LoginScreen.route,
      ),
    );
  }
}
