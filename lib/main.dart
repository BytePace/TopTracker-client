import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tt_bytepace/src/app.dart';
import 'package:tt_bytepace/src/features/login/bloc/auth_bloc.dart';
import 'package:tt_bytepace/src/features/login/data/auth_repository.dart';
import 'package:tt_bytepace/src/features/login/data/data_sources/auth_data_sources.dart';
import 'package:tt_bytepace/src/features/projects/bloc/project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/data/data_sources/project_data_source.dart';
import 'package:tt_bytepace/src/features/projects/data/project_repository.dart';
import 'package:tt_bytepace/src/features/users/data/data_sources/user_data_source.dart';
import 'package:tt_bytepace/src/features/users/data/user_repository.dart';
import 'package:tt_bytepace/src/theme/light_mode.dart';

void main() {
  initGetIt();
  runApp(const MainApp());
}

void initGetIt() async {
  final dio = Dio(BaseOptions(baseUrl: "https://tracker-api.toptal.com"));

  GetIt.I.registerSingleton(
    ProjectBloc(
      projectRepository: ProjectRepository(
        networkProjectDataSource: NetworkProjectDataSource(dio: dio),
      ),
      userRepository: UserRepository(
        networkUserDataSource: NetworkUserDataSource(dio: dio),
      ),
    ),
  );

  GetIt.I.registerSingleton<AuthBloc>(
    AuthBloc(
      authRepository: AuthRepository(
        networkAuthDataSources: NetworkAuthDataSources(dio: dio),
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
