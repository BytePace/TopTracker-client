import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tt_bytepace/src/features/projects/bloc/detail_project_bloc/detail_project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';

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

    DetailProjectBloc buildBloc() {
      return DetailProjectBloc(
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
        expect(buildBloc().state, equals(DetailProjectInitial()));
      });
    });

    group("InitialEvent", () {
      const project = DetailProjectModel(
          currentUserRole: 'worker',
          users: [],
          invitations: [],
          id: 208305,
          name: 'ИПР',
          engagements: []);
      blocTest<DetailProjectBloc, DetailProjectState>(
        'emits [DetailProjectListLoading and DetailProjectListLoaded] when LoadDetailProjectEvent is added.',
        build: () => buildBloc(),
        wait: const Duration(seconds: 1),
        act: (bloc) => bloc.add(LoadDetailProjectEvent(projectID: 208305)),
        expect: () => [
          DetailProjectListLoading(),
          DetailProjectListLoaded(detailProjectModel: project)
        ],
      );
      blocTest<DetailProjectBloc, DetailProjectState>(
          'emits [DetailProjectListMessage and DetailProjectListLoaded] when DeleteUserEvent is added.',
          build: () => buildBloc(),
          wait: const Duration(seconds: 1),
          act: (bloc) => bloc.add(DeleteUserEvent(projectID: 0, profileID: 0)),
          expect: () => [
                DetailProjectListMessage(message: "Пользователь удален"),
                DetailProjectListLoaded(detailProjectModel: project)
              ]);

      blocTest<DetailProjectBloc, DetailProjectState>(
          'emits [DetailProjectListMessage and DetailProjectListLoaded] when AddUserEvent is added.',
          build: () => buildBloc(),
          wait: const Duration(seconds: 1),
          act: (bloc) => bloc
              .add(AddUserEvent(email: '', role: '', rate: '', projectID: 0)),
          expect: () => [
                DetailProjectListMessage(message: "Пользователь добавлен"),
                DetailProjectListLoaded(detailProjectModel: project)
              ]);
      blocTest<DetailProjectBloc, DetailProjectState>(
          'emits [DetailProjectListMessage and DetailProjectListLoaded] when AddWorkTimeEvent is added.',
          build: () => buildBloc(),
          wait: const Duration(seconds: 1),
          act: (bloc) => bloc.add(AddWorkTimeEvent(
              projectID: 0, description: '', endTime: '', startTime: '')),
          expect: () => [
                DetailProjectListMessage(message: "time added"),
                DetailProjectListLoaded(detailProjectModel: project)
              ]);
      blocTest<DetailProjectBloc, DetailProjectState>(
          'emits [DetailProjectListMessage and DetailProjectListLoaded] when RevokeInviteEvent is added.',
          build: () => buildBloc(),
          wait: const Duration(seconds: 1),
          act: (bloc) =>
              bloc.add(RevokeInviteEvent(projectID: 0, invitationsID: 0)),
          expect: () => [
                DetailProjectListMessage(message: "Приглашение отменено"),
                DetailProjectListLoaded(detailProjectModel: project)
              ]);
    });
  });
}
