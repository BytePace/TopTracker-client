import 'package:flutter_test/flutter_test.dart';
import 'package:tt_bytepace/src/features/projects/data/data_sources/project_data_source.dart';
import 'package:tt_bytepace/src/features/projects/data/data_sources/savable_project_data_source.dart';
import 'package:tt_bytepace/src/features/projects/data/project_repository.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/detail_project_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/project_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';

import '../../database_test.dart';

import 'data_sources/project_db_data_sources_test.dart';
import 'data_sources/project_network_data_sources_test.dart';

void main() {
  late ProjectRepositoryTest projectRepositoryTest;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    projectRepositoryTest = ProjectRepositoryTest(
        networkProjectDataSource: NetworkProjectDataSourceTest(),
        dbProjectDataSource:
            DbProjectDataSourceTest(database: DBProviderTest.db.database));
  });
  group("Project repository test", () {
    test(
        'test get projects network, update projects in db and get projects from db',
        () async {
      final projects =
          await projectRepositoryTest.getNetworkProjects(); //get from network
      final expectProject = [
        ProjectModel(
            adminName: "Tatiana Tytar",
            id: 1,
            name: '1',
            createdAt: "1",
            profilesIDs: [1],
            archivedAt: null,
            currentUser: '1')
      ];
      expect(projects, expectProject);

      await projectRepositoryTest
          .updateProject(projects); //update and save id db

      expect(await projectRepositoryTest.getProjects(),
          expectProject); //get from db
    });

    test('test get detail project', () async {
      final detailProject =
          await projectRepositoryTest.getDetailProject(208305);
      const expectDetailPrject = DetailProjectModel(
          users: [],
          invitations: [],
          id: 208305,
          name: 'ИПР',
          engagements: [],
          currentUserRole: 'worker');
      expect(detailProject, expectDetailPrject);
    });

    test('test archive project', () async {
      await projectRepositoryTest.archiveProject(1);
      final projects = await projectRepositoryTest.getProjects();
      ProjectModel project = ProjectModel(
          id: 0,
          name: "",
          adminName: '',
          createdAt: '',
          profilesIDs: [0],
          archivedAt: '',
          currentUser: '');
      for (var element in projects) {
        if (element.id == 1) {
          project = element;
        }
      }
      final expectDetailPrject = ProjectModel(
          adminName: "Tatiana Tytar",
          id: 1,
          name: '1',
          createdAt: "1",
          profilesIDs: [1],
          archivedAt: '2024-04-09',
          currentUser: '1');
      expect(project, expectDetailPrject);
    });
    test('test restore project', () async {
      await projectRepositoryTest.restoreProject(1);
      final projects = await projectRepositoryTest.getProjects();
      ProjectModel project = ProjectModel(
          id: 0,
          name: "",
          adminName: '',
          createdAt: '',
          profilesIDs: [0],
          archivedAt: '',
          currentUser: '');
      for (var element in projects) {
        if (element.id == 1) {
          project = element;
        }
      }
      final expectDetailPrject = ProjectModel(
          adminName: "Tatiana Tytar",
          id: 1,
          name: '1',
          createdAt: "1",
          profilesIDs: [1],
          archivedAt: null,
          currentUser: '1');
      expect(project, expectDetailPrject);
    });

    test('test delete project', () async {
      await projectRepositoryTest.deleteProject(1);
      final projects = await projectRepositoryTest.getProjects();
      ProjectModel? project;

      for (var element in projects) {
        if (element.id == 1) {
          project = element;
        }
      }
      expect(project, null);
    });
  });
}

class ProjectRepositoryTest implements IProjectRepository {
  final IProjectDataSource _networkProjectDataSource;
  final ISavableProjectDataSource _dbProjectDataSource;

  ProjectRepositoryTest(
      {required IProjectDataSource networkProjectDataSource,
      required ISavableProjectDataSource dbProjectDataSource})
      : _networkProjectDataSource = networkProjectDataSource,
        _dbProjectDataSource = dbProjectDataSource;

  @override
  Future<List<ProjectModel>> getProjects() async {
    var dtos = <ProjectDto>[];
    try {
      print("gets [prprp]");
      dtos = await _dbProjectDataSource.getProjects();
    } catch (e) {
      print(e);
    }
    print(dtos.map((e) => ProjectModel.fromDto(e)).toList());
    return dtos.map((e) => ProjectModel.fromDto(e)).toList();
  }

  @override
  Future<List<ProjectModel>> getNetworkProjects() async {
    var dtos = <ProjectDto>[];
    try {
      dtos = await _networkProjectDataSource.getProjects();
    } on Exception {
      throw Exception;
    }
    return dtos.map((e) => ProjectModel.fromDto(e)).toList();
  }

  @override
  Future<DetailProjectModel> getDetailProject(int id) async {
    var dto = const DetailProjectDto(
      users: [],
      invitations: [],
      id: 1,
      name: '',
      engagements: [],
      currentUserRole: '',
    );
    try {
      dto = await _networkProjectDataSource.getDetailProject(id);
      await _dbProjectDataSource.updateDetailProject(dto);
    } catch (e) {
      dto = await _dbProjectDataSource.getDetailProject(id);
      print("no connection wi fi $e");
    }
    return DetailProjectModel.fromDto(dto);
  }

  @override
  Future<void> restoreProject(int projectID) async {
    await _networkProjectDataSource.restoreProject(projectID);
    await _dbProjectDataSource.restoreProject(projectID);
  }

  @override
  Future<void> deleteProject(int projectID) async {
    await _networkProjectDataSource.deleteProject(projectID);
    await _dbProjectDataSource.deleteProject(projectID);
  }

  @override
  Future<void> updateProject(List<ProjectModel> projects) async {
    await _dbProjectDataSource.updateProject(projects);
  }

  @override
  Future<void> dropDB() async {
    await _dbProjectDataSource.dropDB();
  }

  @override
  Future<void> archiveProject(int projectID) async {
    await _networkProjectDataSource.archiveProject(projectID);
    await _dbProjectDataSource.archiveProject(projectID);
  }
}
