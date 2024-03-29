import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/app.dart';
import 'package:tt_bytepace/src/features/login/bloc/auth_bloc.dart';
import 'package:tt_bytepace/src/features/login/data/auth_repository.dart';
import 'package:tt_bytepace/src/features/login/data/data_sources/auth_data_sources.dart';
import 'package:tt_bytepace/src/features/menu/bloc/ProjectListBloc/project_list_bloc.dart';
import 'package:tt_bytepace/src/features/projects/data/data_sources/project_data_source.dart';
import 'package:tt_bytepace/src/features/users/services/users_services.dart';
import 'package:tt_bytepace/src/theme/light_mode.dart';

void main() {
  initGetIt();
  runApp(const MainApp());
}

void initGetIt() async {
  GetIt.I.registerSingleton<NetworkProjectDataSource>(NetworkProjectDataSource(dio: Dio()));
  GetIt.I.registerSingleton<UserServices>(UserServices());
  GetIt.I.registerSingleton<ProjectListBloc>(ProjectListBloc(
      projectService: GetIt.I<NetworkProjectDataSource>(),
      userServices: GetIt.I<UserServices>()));

  GetIt.I.registerSingleton<AuthBloc>(
    AuthBloc(
      authRepository: AuthRepository(
        networkAuthDataSources: NetworkAuthDataSources(
            dio: Dio(BaseOptions(baseUrl: "https://tracker-api.toptal.com"))),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: lightMode, home: const App());
  }
}
