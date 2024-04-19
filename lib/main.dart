import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:tt_bytepace/src/app.dart';
import 'package:tt_bytepace/src/database/database.dart';
import 'package:tt_bytepace/src/features/login/bloc/auth_bloc.dart';
import 'package:tt_bytepace/src/features/login/data/auth_repository.dart';
import 'package:tt_bytepace/src/features/login/data/data_sources/auth_data_sources.dart';
import 'package:tt_bytepace/src/features/login/view/login_screen.dart';
import 'package:tt_bytepace/src/features/profile/data/data_sources/profile_data_sources.dart';
import 'package:tt_bytepace/src/features/profile/data/profile_repository.dart';
import 'package:tt_bytepace/src/features/projects/bloc/detail_project_bloc/detail_project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/bloc/project_bloc/project_bloc.dart';

import 'package:tt_bytepace/src/features/projects/data/data_sources/project_data_source.dart';
import 'package:tt_bytepace/src/features/projects/data/data_sources/savable_project_data_source.dart';
import 'package:tt_bytepace/src/features/projects/data/project_repository.dart';
import 'package:tt_bytepace/src/features/users/data/data_sources/savable_user_data_source.dart';
import 'package:tt_bytepace/src/features/users/data/data_sources/user_data_source.dart';
import 'package:tt_bytepace/src/features/users/data/user_repository.dart';
import 'package:tt_bytepace/src/resources/theme.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initGetIt();
    runApp(const MainApp());
  }, (error, stack) {
    GetIt.I<Talker>().handle(error, stack, "Uncaught app exeption");
  });
}

initGetIt() async {
  final talker = TalkerFlutter.init(
    filter: BaseTalkerFilter(types: []),
    settings: TalkerSettings(enabled: true),
  );
  GetIt.I.registerSingleton<Talker>(talker);
  talker.verbose('Talker initialization completed');

  final talkerDioLogger = TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(printResponseData: false));

  final dio = Dio(BaseOptions(baseUrl: "https://tracker-api.toptal.com"));
  dio.interceptors.add(talkerDioLogger);
  final Database database = await DBProvider.db.database;
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  Bloc.observer = TalkerBlocObserver(
      talker: talker,
      settings: const TalkerBlocLoggerSettings(printStateFullData: false));

  GetIt.I.registerSingleton<ProjectBloc>(
    ProjectBloc(
      projectRepository: ProjectRepository(
        networkProjectDataSource:
            NetworkProjectDataSource(dio: dio, prefs: prefs),
        dbProjectDataSource: DbProjectDataSource(database: database),
      ),
      userRepository: UserRepository(
        networkUserDataSource: NetworkUserDataSource(dio: dio, prefs: prefs),
        dbUserDataSource: DbUserDataSource(database: database),
      ),
    ),
  );

  GetIt.I.registerFactory<DetailProjectBloc>(() {
    return DetailProjectBloc(
      projectRepository: ProjectRepository(
        dbProjectDataSource: DbProjectDataSource(database: database),
        networkProjectDataSource:
            NetworkProjectDataSource(dio: dio, prefs: prefs),
      ),
      userRepository: UserRepository(
        dbUserDataSource: DbUserDataSource(database: database),
        networkUserDataSource: NetworkUserDataSource(dio: dio, prefs: prefs),
      ),
    );
  });

  GetIt.I.registerSingleton<AuthBloc>(
    AuthBloc(
      authRepository: AuthRepository(
        networkAuthDataSources: NetworkAuthDataSources(dio: dio, prefs: prefs),
      ),
    ),
  );

  GetIt.I.registerSingleton<ProfileRepository>(ProfileRepository(
    networkProfileDataSources: NetworkProfileDataSources(dio: dio),
  ));

  talker.info("Repositories initialization cpmpleted");
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [TalkerRouteObserver(GetIt.I<Talker>())],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const App(),
        '/login': (context) => const LoginScreen()
      },
    );
  }
}
