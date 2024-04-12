import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tt_bytepace/src/features/projects/bloc/project_bloc/project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';
import 'package:tt_bytepace/src/features/users/models/all_users_model.dart';

import '../../database_test.dart';
import '../project_repository_test/data_sources/project_db_data_sources_test.dart';
import '../project_repository_test/data_sources/project_network_data_sources_test.dart';
import '../project_repository_test/project_repository_test.dart';
import '../user_repository_test/data_sources/user_db_data_source_test.dart';
import '../user_repository_test/data_sources/user_network_data_sources_test.dart';
import '../user_repository_test/user_repository_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group("detail bloc", () {
    setUp(() {});

    ProjectBloc buildBloc() {
      return ProjectBloc(
          projectRepository: ProjectRepositoryTest(
              networkProjectDataSource: NetworkProjectDataSourceTest(),
              dbProjectDataSource: DbProjectDataSourceTest(
                  database: DBProviderTest.db.database)),
          userRepository: UserRepositoryTest(
              dbUserDataSource:
                  DbUserDataSourceTest(database: DBProviderTest.db.database),
              networkUserDataSource: NetworkUserDataSourceTest()));
    }

    group("constructor", () {
      test("works properly", () {
        expect(buildBloc, returnsNormally);
      });

      test("has correct initial state", () {
        expect(buildBloc().state, equals(ProjectInitial()));
      });
    });

    group("InitialEvent", () {
      final project = ProjectModel(
          id: 1,
          name: "1",
          adminName: "Tatiana Tytar",
          createdAt: "2018-04-06T12:56:24+06:00",
          profilesIDs: [1],
          archivedAt: null,
          currentUser: "1");
      final allUsersLoading =
          UserModel(userID: 0, name: "Loading...", email: '');
      final allUsersLoad = UserModel(userID: 0, name: "", email: '');

      blocTest<ProjectBloc, ProjectState>(
        'emits [ProjectListLoading and ProjectListLoaded] when LoadProjectEvent is added.',
        build: () => buildBloc(),
        wait: const Duration(seconds: 1),
        act: (bloc) => bloc.add(LoadProjectEvent()),
        expect: () => [
          ProjectListLoading(),
          ProjectListLoaded(
              projects: [project],
              allProfileID: [],
              allUser: [allUsersLoading]),
          ProjectListLoaded(
              projects: [project],
              allProfileID: [ProfileIdModel(profileID: 0, name: "")],
              allUser: [allUsersLoad]),
        ],
      );
      blocTest<ProjectBloc, ProjectState>(
          'emits [ProjectListLoading and ProjectListLoaded] when UpdateProjectEvent is added.',
          build: () => buildBloc(),
          wait: const Duration(seconds: 1),
          act: (bloc) => bloc.add(UpdateProjectEvent()),
          expect: () => [
                ProjectListLoading(),
                ProjectListLoaded(
                    projects: [project],
                    allProfileID: [ProfileIdModel(profileID: 0, name: "")],
                    allUser: [allUsersLoading]),
                ProjectListLoaded(
                    projects: [project],
                    allProfileID: [ProfileIdModel(profileID: 0, name: "")],
                    allUser: [allUsersLoad]),
              ]);

      blocTest<ProjectBloc, ProjectState>(
          'emits [ProjectListMessage and ProjectListLoaded] when RestoreProjectEvent is added.',
          build: () => buildBloc(),
          wait: const Duration(seconds: 1),
          act: (bloc) => bloc.add(RestoreProjectEvent(id: 0)),
          expect: () => [
                ProjectListMessage(message: "Проект разархивирован"),
                ProjectListLoaded(
                  allUser: [allUsersLoad],
                  projects: [project],
                  allProfileID: [ProfileIdModel(profileID: 0, name: "")],
                ),
              ]);

      blocTest<ProjectBloc, ProjectState>(
          'emits [ProjectListMessage and ProjectListLoaded] when DeleteProjectEvent is added.',
          build: () => buildBloc(),
          wait: const Duration(seconds: 1),
          act: (bloc) => bloc.add(DeleteProjectEvent(id: 0)),
          expect: () => [
                ProjectListMessage(message: "Проект удален"),
                ProjectListLoaded(allUser: [], projects: [], allProfileID: []),
              ]);

      blocTest<ProjectBloc, ProjectState>(
          'emits [ProjectListMessage and ProjectListLoaded] when ArchiveProjectEvent is added.',
          build: () => buildBloc(),
          wait: const Duration(seconds: 1),
          act: (bloc) => bloc.add(ArchiveProjectEvent(id: 0)),
          expect: () => [
                ProjectListMessage(message: "Проект архивирован"),
                ProjectListLoaded(
                  allUser: [allUsersLoad],
                  projects: [project],
                  allProfileID: [ProfileIdModel(profileID: 0, name: "")],
                ),
              ]);
    });
  });
}
