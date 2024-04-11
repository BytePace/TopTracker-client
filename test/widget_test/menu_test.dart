import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:tt_bytepace/src/features/login/bloc/auth_bloc.dart';
import 'package:tt_bytepace/src/features/profile/data/profile_repository.dart';
import 'package:tt_bytepace/src/features/projects/bloc/detail_project_bloc/detail_project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/bloc/project_bloc/project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/view/menu_screen.dart';

import '../unit_test/profile_repository_test/profile_network_data_source.dart';
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
  testWidgets("menu screen test", (WidgetTester tester) async {
    initGetItTest();

    await tester.pumpWidget(
      const MaterialApp(
        home: MenuScreen(),
      ),
    );
    await tester.pump();

    var appbar = find.text("Projects"); //Смотрим есть ли appbar и bottomTabBar
    expect(appbar, findsExactly(2));

    await tester.pumpAndSettle();

    var project = find.byType(Card); //находим два проекта
    expect(project, findsExactly(2));

    var searchTextField = find.byKey(const Key(
        "searchTextField")); //используем поиск находим проект с названием 2
    await tester.enterText(searchTextField, "2");
    await tester.pump();
    expect(find.byType(Card), findsOneWidget); //находим один проект

    // Проверяем начальное состояние BottomNavigationBar
    expect(find.byIcon(Icons.cases_rounded), findsOneWidget);
    expect(find.byIcon(Icons.badge_rounded), findsOneWidget);
    expect(find.byIcon(Icons.bar_chart), findsOneWidget);

    // Кликаем на элемент 'Archived Projects'
    await tester.tap(find.byIcon(Icons.badge_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsOneWidget); //находим там один проект

    //кликаем на Users
    await tester.tap(find.byIcon(Icons.bar_chart));
    await tester.pumpAndSettle();
    final user = find.text("Aleks");//в users всего один пользователь
    expect(user, findsOneWidget);

    await tester.tap(user);
    await tester.pumpAndSettle();
    expect(find.text("1"), findsOneWidget); //смотрим проекты пользователя 

    //возвращаемся и кликаем на иконку профиля
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    expect(find.text("User Stats"), findsOneWidget); //проверям совпадает ли appbar
    expect(find.text("name: Aleksandr Sherbakov"), findsOneWidget);
    expect(find.text("current week hours: 10.0"), findsOneWidget);//проверяем что именно нужное значение отображается
  });
}

void initGetItTest() {
  GetIt.I.registerSingleton<DetailProjectBloc>(
    DetailProjectBloc(
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

  GetIt.I.registerSingleton<ProfileRepository>(
    ProfileRepository(
      networkProfileDataSources: NetworkProfileDataSourcesTest(),
    ),
  );
  GetIt.I.registerSingleton<AuthBloc>(
    AuthBloc(
      projectRepository: ProjectRepositoryTest(
        dbProjectDataSource: DbProjectDataSourceMockTest(),
        networkProjectDataSource: NetworkProjectDataSourceTest(),
      ),
      authRepository: AuthRepositoryTest(
        networkAuthDataSources: NetworkAuthDataSourcesTest(),
      ),
    ),
  );
}
