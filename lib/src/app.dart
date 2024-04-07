import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tt_bytepace/src/features/login/bloc/auth_bloc.dart';
import 'package:tt_bytepace/src/features/login/view/login_screen.dart';
import 'package:tt_bytepace/src/features/projects/bloc/project_bloc/project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/view/menu_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    GetIt.I<AuthBloc>().add(InitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => GetIt.I<AuthBloc>(),
        child: BlocBuilder<AuthBloc, AuthState>(
          bloc: GetIt.I<AuthBloc>(),
          builder: (BuildContext context, state) {
            if (state is IsLoginState) {
              return const LoginScreen();
            } else if (state is LoginSuccessState) {
              return BlocProvider<ProjectBloc>(
                create: (context) => GetIt.I<ProjectBloc>(),
                child: const MenuScreen(),
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
