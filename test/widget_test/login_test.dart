import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:tt_bytepace/src/app.dart';
import 'package:tt_bytepace/src/features/login/bloc/auth_bloc.dart';
import 'package:tt_bytepace/src/features/projects/bloc/project_bloc/project_bloc.dart';
import '../unit_test/project_repository_test/data_sources/project_network_data_sources_test.dart';
import '../unit_test/project_repository_test/project_repository_test.dart';
import '../unit_test/user_repository_test/data_sources/user_network_data_sources_test.dart';
import '../unit_test/user_repository_test/user_repository_test.dart';
import 'auth_repository_test/auth_data_source_test.dart';
import 'auth_repository_test/auth_reposutory_test.dart';
import 'mock_db_data_sources/mock_db_project_data_source.dart';
import 'mock_db_data_sources/mock_db_user_data_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets("Login screen test", (WidgetTester tester) async {
    GetIt.I.registerSingleton<ProjectBloc>(
      ProjectBloc(
        projectRepository: ProjectRepositoryTest(
          networkProjectDataSource: NetworkProjectDataSourceTest(),
          dbProjectDataSource: DbProjectDataSourceMockTest(),
        ),
        userRepository: UserRepositoryTest(
          networkUserDataSource: NetworkUserDataSourceTest(),
          dbUserDataSource: DbUserDataSourceMockTest(),
        ),
      ),
    );

    GetIt.I.registerSingleton<AuthBloc>(
      AuthBloc(
        authRepository: AuthRepositoryTest(
          networkAuthDataSources: NetworkAuthDataSourcesTest(),
        ),
      ),
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: App(),
      ),
    );
    await tester.pump();
    var emailTextField = find.byKey(const Key('emailTextField'));
    var passwordTextField = find.byKey(const Key('passwordTextField'));
    expect(emailTextField, findsOneWidget);
    expect(passwordTextField, findsOneWidget);

    await tester.enterText(emailTextField, "aleksandr.sherbakov@bytepace.com");
    expect(find.text("aleksandr.sherbakov@bytepace.com"), findsOneWidget);

    await tester.enterText(passwordTextField, "aleksandr.sherb");
    expect(find.text("aleksandr.sherb"), findsOneWidget);

    var button = find.text("log in");
    expect(button, findsOneWidget);
    await tester.tap(button);
    await tester.pump();

    var appbar = find.text("Projects");
    expect(appbar, findsWidgets);

    await tester.pumpAndSettle();

    var project = find.byType(Card);
    expect(project, findsWidgets);
  });
}
