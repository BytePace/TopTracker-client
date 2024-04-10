import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:tt_bytepace/src/features/projects/bloc/project_bloc/project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/view/menu_screen.dart';

import '../unit_test/project_repository_test/data_sources/project_network_data_sources_test.dart';
import '../unit_test/project_repository_test/project_repository_test.dart';
import '../unit_test/user_repository_test/data_sources/user_network_data_sources_test.dart';
import '../unit_test/user_repository_test/user_repository_test.dart';
import 'mock_db_data_sources/mock_db_project_data_source.dart';
import 'mock_db_data_sources/mock_db_user_data_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets("menu screen test", (WidgetTester tester) async {
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
    await tester.pumpWidget(
      const MaterialApp(
        home: MenuScreen(),
      ),
    );
    await tester.pump();

    var appbar = find.text("Projects");
    expect(appbar, findsWidgets);

    await tester.pumpAndSettle();

    var project = find.byType(Card); //находим два проекта
    expect(project, findsWidgets);

    var searchTextField = find.byKey(const Key(
        "searchTextField")); //используем поиск находим проект с названием 2
    await tester.enterText(searchTextField, "2");
    await tester.pump();
    expect(find.byType(Card), findsOneWidget);

    // Проверяем начальное состояние BottomNavigationBar
    expect(find.byIcon(Icons.cases_rounded), findsOneWidget);
    expect(find.byIcon(Icons.badge_rounded), findsOneWidget);
    expect(find.byIcon(Icons.bar_chart), findsOneWidget);

    // Кликаем на элемент 'Archived Projects'
    await tester.tap(find.byIcon(Icons.badge_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsOneWidget);

    // Проверяем изменение BottomNavigationBar после клика
    expect(find.byIcon(Icons.cases_rounded), findsOneWidget);
    expect(find.byIcon(Icons.badge_rounded), findsOneWidget);
    expect(find.byIcon(Icons.bar_chart), findsOneWidget);
  });
}
