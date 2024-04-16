import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/app.dart';
import 'package:tt_bytepace/src/database/database.dart';
import 'package:tt_bytepace/src/features/login/bloc/auth_bloc.dart';
import 'package:tt_bytepace/src/features/login/data/auth_repository.dart';
import 'package:tt_bytepace/src/features/login/data/data_sources/auth_data_sources.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initGetIt();
  runApp(const MainApp());
}

initGetIt() async {
  final dio = Dio(BaseOptions(baseUrl: "https://tracker-api.toptal.com"));
  final Database database = await DBProvider.db.database;
  final SharedPreferences prefs = await SharedPreferences.getInstance();

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
        theme: CustomTheme.lightTheme,
        darkTheme: CustomTheme.darkTheme,
        home: const Scaffold(body: App()));
  }
}
